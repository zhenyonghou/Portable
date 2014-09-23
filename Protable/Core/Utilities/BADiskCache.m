#import "BADiskCache.h"

#define BADiskCacheError(error) if (error) { NSLog(@"%@ (%d) ERROR: %@", \
                                    [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
                                    __LINE__, [error localizedDescription]); }

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
    #define BACacheStartBackgroundTask() UIBackgroundTaskIdentifier taskID = UIBackgroundTaskInvalid; \
            taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{ \
            [[UIApplication sharedApplication] endBackgroundTask:taskID]; }];
    #define BACacheEndBackgroundTask() [[UIApplication sharedApplication] endBackgroundTask:taskID];
#else
    #define BACacheStartBackgroundTask()
    #define BACacheEndBackgroundTask()
#endif

NSString * const BADiskCachePrefix = @"com.mumu.DiskCache";
NSString * const BADiskCacheSharedName = @"DiskCacheShared";

@interface BADiskCache ()
@property (assign) NSUInteger byteCount;
@property (strong, nonatomic) NSURL *cacheURL;
@property (assign, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) NSMutableDictionary *dates;
@property (strong, nonatomic) NSMutableDictionary *sizes;
@end

@implementation BADiskCache

@synthesize willAddObjectBlock = _willAddObjectBlock;
@synthesize willRemoveObjectBlock = _willRemoveObjectBlock;
@synthesize willRemoveAllObjectsBlock = _willRemoveAllObjectsBlock;
@synthesize didAddObjectBlock = _didAddObjectBlock;
@synthesize didRemoveObjectBlock = _didRemoveObjectBlock;
@synthesize didRemoveAllObjectsBlock = _didRemoveAllObjectsBlock;
@synthesize byteLimit = _byteLimit;
@synthesize ageLimit = _ageLimit;

#pragma mark - Initialization -

- (instancetype)initWithName:(NSString *)name
{
    if (!name)
        return nil;

    if (self = [super init]) {
        _name = [name copy];
        _queue = [BADiskCache sharedQueue];

        _willAddObjectBlock = nil;
        _willRemoveObjectBlock = nil;
        _willRemoveAllObjectsBlock = nil;
        _didAddObjectBlock = nil;
        _didRemoveObjectBlock = nil;
        _didRemoveAllObjectsBlock = nil;
        
        _byteCount = 0;
        _byteLimit = 0;
        _ageLimit = 0.0;

        _dates = [[NSMutableDictionary alloc] init];
        _sizes = [[NSMutableDictionary alloc] init];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *pathComponent = [[NSString alloc] initWithFormat:@"%@.%@", BADiskCachePrefix, _name];
        _cacheURL = [NSURL fileURLWithPathComponents:@[ [paths objectAtIndex:0], pathComponent ]];

        __weak BADiskCache *weakSelf = self;

        dispatch_async(_queue, ^{
            BADiskCache *strongSelf = weakSelf;
            [strongSelf createCacheDirectory];
            [strongSelf initializeDiskProperties];
        });
    }
    return self;
}

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"%@.%@.%p", BADiskCachePrefix, _name, self];
}

+ (instancetype)sharedCache
{
    static id cache;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        cache = [[self alloc] initWithName:BADiskCacheSharedName];
    });

    return cache;
}

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        queue = dispatch_queue_create([BADiskCachePrefix UTF8String], DISPATCH_QUEUE_SERIAL);
    });

    return queue;
}

- (NSURL *)encodedFileURLForKey:(NSString *)key
{
    if (![key length])
        return nil;

    return [_cacheURL URLByAppendingPathComponent:[self encodedString:key]];
}

#pragma mark - Private Methods -

- (NSString *)keyForEncodedFileURL:(NSURL *)url
{
    NSString *fileName = [url lastPathComponent];
    if (!fileName)
        return nil;

    return [self decodedString:fileName];
}

- (NSString *)encodedString:(NSString *)string
{
    if (![string length])
        return @"";

    CFStringRef static const charsToEscape = CFSTR(".:/");
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        charsToEscape,
                                                                        kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)decodedString:(NSString *)string
{
    if (![string length])
        return @"";

    CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef)string,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)unescapedString;
}

#pragma mark - Private Trash Methods -

+ (dispatch_queue_t)sharedTrashQueue
{
    static dispatch_queue_t trashQueue;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        NSString *queueName = [[NSString alloc] initWithFormat:@"%@.trash", BADiskCachePrefix];
        trashQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(trashQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
    });
    
    return trashQueue;
}

+ (NSURL *)sharedTrashURL
{
    static NSURL *sharedTrashURL;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedTrashURL = [[[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:BADiskCachePrefix isDirectory:YES];
        
        dispatch_async([self sharedTrashQueue], ^{
            if (![[NSFileManager defaultManager] fileExistsAtPath:[sharedTrashURL path]]) {
                NSError *error = nil;
                [[NSFileManager defaultManager] createDirectoryAtURL:sharedTrashURL
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:&error];
                BADiskCacheError(error);
            }
        });
    });
    
    return sharedTrashURL;
}

+(BOOL)moveItemAtURLToTrash:(NSURL *)itemURL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[itemURL path]])
        return NO;

    NSError *error = nil;
    NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSURL *uniqueTrashURL = [[BADiskCache sharedTrashURL] URLByAppendingPathComponent:uniqueString];
    BOOL moved = [[NSFileManager defaultManager] moveItemAtURL:itemURL toURL:uniqueTrashURL error:&error];
    BADiskCacheError(error);
    return moved;
}

+ (void)emptyTrash
{
    BACacheStartBackgroundTask();
    
    dispatch_async([self sharedTrashQueue], ^{        
        NSError *error = nil;
        NSArray *trashedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self sharedTrashURL]
                                                              includingPropertiesForKeys:nil
                                                                                 options:0
                                                                                   error:&error];
        BADiskCacheError(error);

        for (NSURL *trashedItemURL in trashedItems) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtURL:trashedItemURL error:&error];
            BADiskCacheError(error);
        }
            
        BACacheEndBackgroundTask();
    });
}

#pragma mark - Private Queue Methods -

- (BOOL)createCacheDirectory
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[_cacheURL path]])
        return NO;

    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:_cacheURL
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    BADiskCacheError(error);

    return success;
}

- (void)initializeDiskProperties
{
    NSUInteger byteCount = 0;
    NSArray *keys = @[ NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey ];

    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:_cacheURL
                                                   includingPropertiesForKeys:keys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    BADiskCacheError(error);

    for (NSURL *fileURL in files) {
        NSString *key = [self keyForEncodedFileURL:fileURL];

        error = nil;
        NSDictionary *dictionary = [fileURL resourceValuesForKeys:keys error:&error];
        BADiskCacheError(error);

        NSDate *date = [dictionary objectForKey:NSURLContentModificationDateKey];
        if (date)
            [_dates setObject:date forKey:key];

        NSNumber *fileSize = [dictionary objectForKey:NSURLTotalFileAllocatedSizeKey];
        if (fileSize) {
            [_sizes setObject:fileSize forKey:key];
            byteCount += [fileSize unsignedIntegerValue];
        }
    }

    if (byteCount > 0)
        self.byteCount = byteCount; // atomic
}

- (BOOL)setFileModificationDate:(NSDate *)date forURL:(NSURL *)fileURL
{
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] setAttributes:@{ NSFileModificationDate: date }
                                                    ofItemAtPath:[fileURL path]
                                                           error:&error];
    BADiskCacheError(error);

    if (success)
        [_dates setObject:date forKey:[self keyForEncodedFileURL:fileURL]];

    return success;
}

- (BOOL)removeFileAndExecuteBlocksForKey:(NSString *)key
{
    NSURL *fileURL = [self encodedFileURLForKey:key];
    if (!fileURL || ![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]])
        return NO;

    if (_willRemoveObjectBlock)
        _willRemoveObjectBlock(self, key, nil, fileURL);

    BOOL trashed = [BADiskCache moveItemAtURLToTrash:fileURL];
    if (!trashed)
        return NO;
    
    [BADiskCache emptyTrash];

    NSNumber *byteSize = [_sizes objectForKey:key];
    if (byteSize)
        self.byteCount = _byteCount - [byteSize unsignedIntegerValue]; // atomic

    [_sizes removeObjectForKey:key];
    [_dates removeObjectForKey:key];

    if (_didRemoveObjectBlock)
        _didRemoveObjectBlock(self, key, nil, fileURL);

    return YES;
}

- (void)trimDiskToSize:(NSUInteger)trimByteCount
{
    if (_byteCount <= trimByteCount)
        return;

    NSArray *keysSortedBySize = [_sizes keysSortedByValueUsingSelector:@selector(compare:)];

    for (NSString *key in [keysSortedBySize reverseObjectEnumerator]) { // largest objects first
        [self removeFileAndExecuteBlocksForKey:key];

        if (_byteCount <= trimByteCount)
            break;
    }
}

- (void)trimDiskToSizeByDate:(NSUInteger)trimByteCount
{
    if (_byteCount <= trimByteCount)
        return;

    NSArray *keysSortedByDate = [_dates keysSortedByValueUsingSelector:@selector(compare:)];

    for (NSString *key in keysSortedByDate) { // oldest objects first
        [self removeFileAndExecuteBlocksForKey:key];

        if (_byteCount <= trimByteCount)
            break;
    }
}

- (void)trimDiskToDate:(NSDate *)trimDate
{
    NSArray *keysSortedByDate = [_dates keysSortedByValueUsingSelector:@selector(compare:)];
    
    for (NSString *key in keysSortedByDate) { // oldest files first
        NSDate *accessDate = [_dates objectForKey:key];
        if (!accessDate)
            continue;
        
        if ([accessDate compare:trimDate] == NSOrderedAscending) { // older than trim date
            [self removeFileAndExecuteBlocksForKey:key];
        } else {
            break;
        }
    }
}

- (void)trimToAgeLimitRecursively
{
    if (_ageLimit == 0.0)
        return;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:-_ageLimit];
    [self trimDiskToDate:date];
    
    __weak BADiskCache *weakSelf = self;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_ageLimit * NSEC_PER_SEC));
    dispatch_after(time, _queue, ^(void) {
        BADiskCache *strongSelf = weakSelf;
        [strongSelf trimToAgeLimitRecursively];
    });
}

#pragma mark - Public Asynchronous Methods -

- (void)objectForKey:(NSString *)key block:(BADiskCacheObjectBlock)block
{
    NSDate *now = [[NSDate alloc] init];

    if (!key || !block)
        return;

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];
        id <NSCoding> object = nil;

        if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:[fileURL path]];
            [strongSelf setFileModificationDate:now forURL:fileURL];
        }

        block(strongSelf, key, object, fileURL);
    });
}

- (void)fileURLForKey:(NSString *)key block:(BADiskCacheObjectBlock)block
{
    NSDate *now = [[NSDate alloc] init];

    if (!key || !block)
        return;

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];

        if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
            [strongSelf setFileModificationDate:now forURL:fileURL];
        } else {
            fileURL = nil;
        }

        block(strongSelf, key, nil, fileURL);
    });
}

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(BADiskCacheObjectBlock)block
{
    NSDate *now = [[NSDate alloc] init];

    if (!key || !object)
        return;

    BACacheStartBackgroundTask();

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];

        if (strongSelf->_willAddObjectBlock)
            strongSelf->_willAddObjectBlock(strongSelf, key, object, fileURL);

        BOOL written = [NSKeyedArchiver archiveRootObject:object toFile:[fileURL path]];

        if (written) {
            [strongSelf setFileModificationDate:now forURL:fileURL];

            NSError *error = nil;
            NSDictionary *values = [fileURL resourceValuesForKeys:@[ NSURLTotalFileAllocatedSizeKey ] error:&error];
            BADiskCacheError(error);

            NSNumber *diskFileSize = [values objectForKey:NSURLTotalFileAllocatedSizeKey];
            if (diskFileSize) {
                [strongSelf->_sizes setObject:diskFileSize forKey:key];
                strongSelf.byteCount = strongSelf->_byteCount + [diskFileSize unsignedIntegerValue]; // atomic
            }
            
            if (strongSelf->_byteLimit > 0 && strongSelf->_byteCount > strongSelf->_byteLimit)
                [strongSelf trimToSizeByDate:strongSelf->_byteLimit block:nil];
        } else {
            fileURL = nil;
        }

        if (strongSelf->_didAddObjectBlock)
            strongSelf->_didAddObjectBlock(strongSelf, key, object, written ? fileURL : nil);

        if (block)
            block(strongSelf, key, object, fileURL);

        BACacheEndBackgroundTask();
    });
}

- (void)removeObjectForKey:(NSString *)key block:(BADiskCacheObjectBlock)block
{
    if (!key)
        return;

    BACacheStartBackgroundTask();

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];
        [strongSelf removeFileAndExecuteBlocksForKey:key];

        if (block)
            block(strongSelf, key, nil, fileURL);

        BACacheEndBackgroundTask();
    });
}

- (void)renameObjectWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey block:(BADiskCacheObjectBlock)block
{
    if (!oldKey || !newKey)
        return;
    
    BACacheStartBackgroundTask();
    
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }
        
        NSURL *oldfileURL = [strongSelf encodedFileURLForKey:oldKey];
        NSURL *newfileURL = [strongSelf encodedFileURLForKey:newKey];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[oldfileURL path]]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtURL:oldfileURL toURL:newfileURL error:&error];

            // 如果有旧数据，移除掉
            {
                NSNumber *byteSize = [_sizes objectForKey:oldKey];
                if (byteSize)
                    self.byteCount = _byteCount - [byteSize unsignedIntegerValue]; // atomic
                [_sizes removeObjectForKey:oldKey];
                [_dates removeObjectForKey:oldKey];
            }
            
            // 增加新的文件
            [strongSelf setFileModificationDate:[NSDate date] forURL:newfileURL];
            NSDictionary *values = [newfileURL resourceValuesForKeys:@[ NSURLTotalFileAllocatedSizeKey ] error:&error];
            NSNumber *diskFileSize = [values objectForKey:NSURLTotalFileAllocatedSizeKey];
            if (diskFileSize) {
                [strongSelf->_sizes setObject:diskFileSize forKey:newKey];
                strongSelf.byteCount = strongSelf->_byteCount + [diskFileSize unsignedIntegerValue]; // atomic
            }
            
            if (strongSelf->_byteLimit > 0 && strongSelf->_byteCount > strongSelf->_byteLimit)
                [strongSelf trimToSizeByDate:strongSelf->_byteLimit block:nil];
        }
        
        if (block)
            block(strongSelf, newKey, nil, newfileURL);
        
        BACacheEndBackgroundTask();
    });
}

- (void)trimToSize:(NSUInteger)trimByteCount block:(BADiskCacheBlock)block
{
    if (trimByteCount == 0) {
        [self removeAllObjects:block];
        return;
    }

    BACacheStartBackgroundTask();
    
    __weak BADiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        [strongSelf trimDiskToSize:trimByteCount];

        if (block)
            block(strongSelf);
        
        BACacheEndBackgroundTask();
    });
}

- (void)trimToDate:(NSDate *)trimDate block:(BADiskCacheBlock)block
{
    if (!trimDate)
        return;

    if ([trimDate isEqualToDate:[NSDate distantPast]]) {
        [self removeAllObjects:block];
        return;
    }
    
    BACacheStartBackgroundTask();

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        [strongSelf trimDiskToDate:trimDate];

        if (block)
            block(strongSelf);
        
        BACacheEndBackgroundTask();
    });
}

- (void)trimToSizeByDate:(NSUInteger)trimByteCount block:(BADiskCacheBlock)block
{
    if (trimByteCount == 0) {
        [self removeAllObjects:block];
        return;
    }

    BACacheStartBackgroundTask();

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        [strongSelf trimDiskToSizeByDate:trimByteCount];

        if (block)
            block(strongSelf);

        BACacheEndBackgroundTask();
    });
}

- (void)removeAllObjects:(BADiskCacheBlock)block
{
    BACacheStartBackgroundTask();
    
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        if (strongSelf->_willRemoveAllObjectsBlock)
            strongSelf->_willRemoveAllObjectsBlock(strongSelf);
        
        [BADiskCache moveItemAtURLToTrash:strongSelf->_cacheURL];
        [BADiskCache emptyTrash];

        [strongSelf createCacheDirectory];

        [strongSelf->_dates removeAllObjects];
        [strongSelf->_sizes removeAllObjects];
        strongSelf.byteCount = 0; // atomic

        if (strongSelf->_didRemoveAllObjectsBlock)
            strongSelf->_didRemoveAllObjectsBlock(strongSelf);

        if (block)
            block(strongSelf);
        
        BACacheEndBackgroundTask();
    });
}

- (void)enumerateObjectsWithBlock:(BADiskCacheObjectBlock)block completionBlock:(BADiskCacheBlock)completionBlock
{
    if (!block)
        return;

    BACacheStartBackgroundTask();

    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        NSArray *keysSortedByDate = [strongSelf->_dates keysSortedByValueUsingSelector:@selector(compare:)];

        for (NSString *key in keysSortedByDate) {
            NSURL *fileURL = [strongSelf encodedFileURLForKey:key];
            block(strongSelf, key, nil, fileURL);
        }

        if (completionBlock)
            completionBlock(strongSelf);

        BACacheEndBackgroundTask();
    });
}

#pragma mark - Public Synchronous Methods -

- (id <NSCoding>)objectForKey:(NSString *)key
{
    if (!key)
        return nil;

    __block id <NSCoding> objectForKey = nil;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self objectForKey:key block:^(BADiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        objectForKey = object;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif

    return objectForKey;
}

- (NSURL *)fileURLForKey:(NSString *)key
{
    if (!key)
        return nil;

    __block NSURL *fileURLForKey = nil;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self fileURLForKey:key block:^(BADiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        fileURLForKey = fileURL;
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif

    return fileURLForKey;
}

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key
{
    if (!object || !key)
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self setObject:object forKey:key block:^(BADiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)removeObjectForKey:(NSString *)key
{
    if (!key)
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self removeObjectForKey:key block:^(BADiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)renameObjectWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey
{
    if (!oldKey || !newKey)
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self renameObjectWithOldKey:oldKey newKey:newKey block:^(BADiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
    
}

- (void)trimToSize:(NSUInteger)byteCount
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self trimToSize:byteCount block:^(BADiskCache *cache) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)trimToDate:(NSDate *)date
{
    if (!date)
        return;

    if ([date isEqualToDate:[NSDate distantPast]]) {
        [self removeAllObjects];
        return;
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self trimToDate:date block:^(BADiskCache *cache) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)trimToSizeByDate:(NSUInteger)byteCount
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self trimToSizeByDate:byteCount block:^(BADiskCache *cache) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)removeAllObjects
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self removeAllObjects:^(BADiskCache *cache) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

- (void)enumerateObjectsWithBlock:(BADiskCacheObjectBlock)block
{
    if (!block)
        return;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self enumerateObjectsWithBlock:block completionBlock:^(BADiskCache *cache) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    #if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
    #endif
}

#pragma mark - Public Thread Safe Accessors -

- (BADiskCacheObjectBlock)willAddObjectBlock
{
    __block BADiskCacheObjectBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _willAddObjectBlock;
    });

    return block;
}

- (void)setWillAddObjectBlock:(BADiskCacheObjectBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_willAddObjectBlock = [block copy];
    });
}

- (BADiskCacheObjectBlock)willRemoveObjectBlock
{
    __block BADiskCacheObjectBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _willRemoveObjectBlock;
    });

    return block;
}

- (void)setWillRemoveObjectBlock:(BADiskCacheObjectBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_willRemoveObjectBlock = [block copy];
    });
}

- (BADiskCacheBlock)willRemoveAllObjectsBlock
{
    __block BADiskCacheBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _willRemoveAllObjectsBlock;
    });

    return block;
}

- (void)setWillRemoveAllObjectsBlock:(BADiskCacheBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_willRemoveAllObjectsBlock = [block copy];
    });
}

- (BADiskCacheObjectBlock)didAddObjectBlock
{
    __block BADiskCacheObjectBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _didAddObjectBlock;
    });

    return block;
}

- (void)setDidAddObjectBlock:(BADiskCacheObjectBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_didAddObjectBlock = [block copy];
    });
}

- (BADiskCacheObjectBlock)didRemoveObjectBlock
{
    __block BADiskCacheObjectBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _didRemoveObjectBlock;
    });

    return block;
}

- (void)setDidRemoveObjectBlock:(BADiskCacheObjectBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_didRemoveObjectBlock = [block copy];
    });
}

- (BADiskCacheBlock)didRemoveAllObjectsBlock
{
    __block BADiskCacheBlock block = nil;

    dispatch_sync(_queue, ^{
        block = _didRemoveAllObjectsBlock;
    });

    return block;
}

- (void)setDidRemoveAllObjectsBlock:(BADiskCacheBlock)block
{
    __weak BADiskCache *weakSelf = self;

    dispatch_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;

        strongSelf->_didRemoveAllObjectsBlock = [block copy];
    });
}

- (NSUInteger)byteLimit
{
    __block NSUInteger byteLimit = 0;
    
    dispatch_sync(_queue, ^{
        byteLimit = _byteLimit;
    });
    
    return byteLimit;
}

- (void)setByteLimit:(NSUInteger)byteLimit
{
    __weak BADiskCache *weakSelf = self;
    
    dispatch_barrier_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;
        
        strongSelf->_byteLimit = byteLimit;

        if (byteLimit > 0)
            [strongSelf trimDiskToSizeByDate:byteLimit];
    });
}

- (NSTimeInterval)ageLimit
{
    __block NSTimeInterval ageLimit = 0.0;
    
    dispatch_sync(_queue, ^{
        ageLimit = _ageLimit;
    });
    
    return ageLimit;
}

- (void)setAgeLimit:(NSTimeInterval)ageLimit
{
    __weak BADiskCache *weakSelf = self;
    
    dispatch_barrier_async(_queue, ^{
        BADiskCache *strongSelf = weakSelf;
        if (!strongSelf)
            return;
        
        strongSelf->_ageLimit = ageLimit;
        
        [strongSelf trimToAgeLimitRecursively];
    });
}

@end
