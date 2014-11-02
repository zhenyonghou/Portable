//
//  BACache.m
//  lxCache
//
//  Created by houzhenyong on 14-9-22.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BAFileDiskCache.h"
#import <UIKit/UIKit.h>

#define BAFileDiskCacheError(error) if (error) { NSLog(@"%@ (%d) ERROR: %@", \
                                    [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
                                    __LINE__, [error localizedDescription]); }

#define BACacheStartBackgroundTask() UIBackgroundTaskIdentifier taskID = UIBackgroundTaskInvalid; \
        taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{ \
[[UIApplication sharedApplication] endBackgroundTask:taskID]; }];

#define BACacheEndBackgroundTask() [[UIApplication sharedApplication] endBackgroundTask:taskID];


NSString * const BAFileDiskCachePrefix = @"com.mumu.DiskCache";
NSString * const BAFileDiskCacheSharedName = @"default_name";

@interface BAFileDiskCache ()

@property (nonatomic, copy) NSString *name;

@property (assign) NSUInteger byteCount;
@property (strong, nonatomic) NSURL *cacheURL;
@property (assign, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) NSMutableDictionary *dates;
@property (strong, nonatomic) NSMutableDictionary *sizes;

@end


#pragma mark- implementation

@implementation BAFileDiskCache


#pragma mark- initialize methods

- (id)initWithName:(NSString *)name
{
    if (!name)
        return nil;
    
    if (self = [super init]) {
        _name = name;
        _queue = [BAFileDiskCache sharedQueue];

//        _willAddObjectBlock = nil;
//        _willRemoveObjectBlock = nil;
//        _willRemoveAllObjectsBlock = nil;
//        _didAddObjectBlock = nil;
//        _didRemoveObjectBlock = nil;
//        _didRemoveAllObjectsBlock = nil;
        
        _byteCount = 0;
        _byteLimit = 0;
        _ageLimit = 0.0;
        
        _dates = [[NSMutableDictionary alloc] init];
        _sizes = [[NSMutableDictionary alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *pathComponent = [[NSString alloc] initWithFormat:@"%@.%@", BAFileDiskCachePrefix, _name];
        _cacheURL = [NSURL fileURLWithPathComponents:@[[paths objectAtIndex:0], pathComponent]];
        
        __weak BAFileDiskCache *weakSelf = self;
        
        dispatch_async(_queue, ^{
            BAFileDiskCache *strongSelf = weakSelf;
            [strongSelf createCacheDirectory];
            [strongSelf initializeDiskProperties];
        });
    }
    return self;
}

+ (instancetype)sharedCache
{
    static id cache;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        cache = [[self alloc] initWithName:BAFileDiskCacheSharedName];
    });
    
    return cache;
}

+ (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        queue = dispatch_queue_create([BAFileDiskCachePrefix UTF8String], DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

- (BOOL)createCacheDirectory
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[_cacheURL path]])
        return NO;
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:_cacheURL
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    BAFileDiskCacheError(error);
    
    return success;
}

- (void)initializeDiskProperties
{
    NSUInteger byteCount = 0;
    NSArray *keys = @[NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
    
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:_cacheURL
                                                   includingPropertiesForKeys:keys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    BAFileDiskCacheError(error);
    
    for (NSURL *fileURL in files) {
        NSString *key = [self keyForEncodedFileURL:fileURL];
        
        error = nil;
        NSDictionary *dictionary = [fileURL resourceValuesForKeys:keys error:&error];
        BAFileDiskCacheError(error);
        
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

#pragma mark- private methods

- (void)trimDiskToSize:(NSUInteger)trimByteCount
{
    if (_byteCount <= trimByteCount)
        return;
    
    NSArray *keysSortedBySize = [_sizes keysSortedByValueUsingSelector:@selector(compare:)];
    
    for (NSString *key in [keysSortedBySize reverseObjectEnumerator]) { // largest objects first
        [self removeFileForKey:key];
        
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
        [self removeFileForKey:key];
        
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
            [self removeFileForKey:key];
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
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_ageLimit * NSEC_PER_SEC));
    dispatch_after(time, _queue, ^(void) {
        BAFileDiskCache *strongSelf = weakSelf;
        [strongSelf trimToAgeLimitRecursively];
    });
}

#pragma mark- public methods

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

- (NSURL *)encodedFileURLForKey:(NSString *)key
{
    if (![key length])
        return nil;
    
    return [_cacheURL URLByAppendingPathComponent:[self encodedString:key]];
}

- (NSString *)keyForEncodedFileURL:(NSURL *)url
{
    NSString *fileName = [url lastPathComponent];
    if (!fileName)
        return nil;
    
    return [self decodedString:fileName];
}

+ (BOOL)removeItemFromDiskAtURL:(NSURL *)itemURL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[itemURL path]])
        return NO;

    NSError *error = nil;
    BOOL remove = [[NSFileManager defaultManager] removeItemAtURL:itemURL error:&error];
    BAFileDiskCacheError(error);
    return remove;
}

- (BOOL)setFileModificationDate:(NSDate *)date forURL:(NSURL *)fileURL
{
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] setAttributes:@{ NSFileModificationDate: date }
                                                    ofItemAtPath:[fileURL path]
                                                           error:&error];
    BAFileDiskCacheError(error);
    
    if (success)
        [_dates setObject:date forKey:[self keyForEncodedFileURL:fileURL]];
    
    return success;
}

- (void)trimToSize:(NSUInteger)trimByteCount block:(BAFileDiskCacheBlock)block
{
    if (trimByteCount == 0) {
        [self removeAll:block];
        return;
    }
    
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
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

- (void)trimToDate:(NSDate *)trimDate block:(BAFileDiskCacheBlock)block
{
    if (!trimDate)
        return;
    
    if ([trimDate isEqualToDate:[NSDate distantPast]]) {
        [self removeAll:block];
        return;
    }
    
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
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

- (void)trimToSizeByDate:(NSUInteger)trimByteCount block:(BAFileDiskCacheBlock)block
{
    if (trimByteCount == 0) {
        [self removeAll:block];
        return;
    }
    
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
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

#pragma mark- 异步接口

- (void)removeFileForKey:(NSString *)key block:(BAFileDiskCacheObjectBlock)block
{
    if (!key) {
        return;
    }
    
    BACacheStartBackgroundTask();
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
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

- (BOOL)removeFileAndExecuteBlocksForKey:(NSString *)key
{
    NSURL *fileURL = [self encodedFileURLForKey:key];
    if (!fileURL || ![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]])
        return NO;

//    if (_willRemoveObjectBlock)
//        _willRemoveObjectBlock(self, key, nil, fileURL);

    BOOL remove = [BAFileDiskCache removeItemFromDiskAtURL:fileURL];
    if (!remove)
        return NO;

    NSNumber *byteSize = [_sizes objectForKey:key];
    if (byteSize)
        self.byteCount = _byteCount - [byteSize unsignedIntegerValue]; // atomic

    [_sizes removeObjectForKey:key];
    [_dates removeObjectForKey:key];

//    if (_didRemoveObjectBlock)
//        _didRemoveObjectBlock(self, key, nil, fileURL);
    
    return YES;
}

- (void)addFileForKey:(NSString *)key block:(BAFileDiskCacheObjectBlock)block
{
    NSDate *now = [[NSDate alloc] init];
    
    if (!key)
        return;
    
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }

        //        if (strongSelf->_willAddObjectBlock)
        //            strongSelf->_willAddObjectBlock(strongSelf, key, object, fileURL);

        
        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];
        
        [strongSelf setFileModificationDate:now forURL:fileURL];
        
        NSError *error = nil;
        NSDictionary *values = [fileURL resourceValuesForKeys:@[ NSURLTotalFileAllocatedSizeKey ] error:&error];
        BAFileDiskCacheError(error);
        
        NSNumber *diskFileSize = [values objectForKey:NSURLTotalFileAllocatedSizeKey];
        if (diskFileSize) {
            [strongSelf->_sizes setObject:diskFileSize forKey:key];
            strongSelf.byteCount = strongSelf->_byteCount + [diskFileSize unsignedIntegerValue]; // atomic
        }
        
        if (strongSelf->_byteLimit > 0 && strongSelf->_byteCount > strongSelf->_byteLimit)
            [strongSelf trimToSizeByDate:strongSelf->_byteLimit block:nil];

//        if (strongSelf->_didAddObjectBlock)
//            strongSelf->_didAddObjectBlock(strongSelf, key, object, written ? fileURL : nil);
        
        if (block)
            block(strongSelf, key, nil, fileURL);
        
        BACacheEndBackgroundTask();
    });
}

- (void)fileURLForKey:(NSString *)key block:(BAFileDiskCacheObjectBlock)block
{
    NSDate *now = [[NSDate alloc] init];
    
    if (!key || !block)
        return;
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
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

- (void)renameFileWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey block:(BAFileDiskCacheObjectBlock)block
{
    if (!oldKey || !newKey)
        return;
    
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
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

- (void)updateForKey:(NSString*)key block:(BAFileDiskCacheObjectBlock)block
{
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(_queue, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSDate *now = [NSDate date];
        
        NSURL *fileURL = [strongSelf encodedFileURLForKey:key];
        
        [strongSelf setFileModificationDate:now forURL:fileURL];
        
        NSError *error = nil;
        NSDictionary *values = [fileURL resourceValuesForKeys:@[NSURLTotalFileAllocatedSizeKey] error:&error];
        BAFileDiskCacheError(error);
        
        NSNumber *diskFileSize = [values objectForKey:NSURLTotalFileAllocatedSizeKey];
        if (diskFileSize) {
            [strongSelf->_sizes setObject:diskFileSize forKey:key];
            NSNumber* oldSize = [strongSelf->_dates objectForKey:key];
            strongSelf.byteCount = strongSelf->_byteCount + [diskFileSize unsignedIntegerValue] - [oldSize unsignedIntegerValue]; // atomic
        }
        
        if (block)
            block(strongSelf, key, nil, fileURL);
    });
}

- (void)removeAll:(BAFileDiskCacheBlock)block
{
    BACacheStartBackgroundTask();
    
    __weak BAFileDiskCache *weakSelf = self;
    
    dispatch_async(_queue, ^{
        BAFileDiskCache *strongSelf = weakSelf;
        if (!strongSelf) {
            BACacheEndBackgroundTask();
            return;
        }
        
//        if (strongSelf->_willRemoveAllObjectsBlock)
//            strongSelf->_willRemoveAllObjectsBlock(strongSelf);
        
        [BAFileDiskCache removeItemFromDiskAtURL:strongSelf->_cacheURL];
        
        [strongSelf createCacheDirectory];
        
        [strongSelf->_dates removeAllObjects];
        [strongSelf->_sizes removeAllObjects];
        strongSelf.byteCount = 0; // atomic

//        if (strongSelf->_didRemoveAllObjectsBlock)
//            strongSelf->_didRemoveAllObjectsBlock(strongSelf);

        if (block)
            block(strongSelf);

        BACacheEndBackgroundTask();
    });
}

#pragma mark- 同步接口

- (NSURL *)fileURLForKey:(NSString *)key
{
    if (!key)
        return nil;
    
    __block NSURL *fileURLForKey = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self fileURLForKey:key block:^(BAFileDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        fileURLForKey = fileURL;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
    
    return fileURLForKey;
}

- (void)addFileForKey:(NSString*)key
{
    if (!key)
        return;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self addFileForKey:key block:^(BAFileDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}

- (void)removeFileForKey:(NSString *)key
{
    if (!key)
        return;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self removeFileForKey:key block:^(BAFileDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}

- (void)renameFileWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey
{
    if (!oldKey || !newKey)
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self renameFileWithOldKey:oldKey newKey:newKey block:^(BAFileDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}

- (void)updateForKey:(NSString*)key
{
    if (!key)
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self updateForKey:key block:^(BAFileDiskCache *cache, NSString *key, id<NSCoding> object, NSURL *fileURL) {
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}

@end
