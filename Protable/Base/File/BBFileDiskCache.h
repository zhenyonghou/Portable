/**
 灵感来自于TMCache.
 与TMCache不同的是，BAFileDiskCache专为大文件缓存而设计，比如音频文件等.
 */

#import <Foundation/Foundation.h>

@class BBFileDiskCache;

typedef void (^BAFileDiskCacheBlock)(BBFileDiskCache *cache);
typedef void (^BAFileDiskCacheObjectBlock)(BBFileDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL);


@interface BBFileDiskCache : NSObject

@property (nonatomic, strong, readonly) NSURL *cacheURL;

@property (nonatomic, assign, readonly) NSUInteger byteCount;

@property (nonatomic, assign) NSUInteger byteLimit;

@property (nonatomic, assign) NSTimeInterval ageLimit;

- (id)initWithName:(NSString *)name;

+ (instancetype)sharedCache;

- (void)addFileForKey:(NSString*)key;

- (void)removeFileForKey:(NSString *)key;

- (void)removeAll:(BAFileDiskCacheBlock)block;

- (void)renameFileWithOldKey:(NSString *)oldKey newKey:(NSString *)newKey;


- (NSURL *)fileURLForKey:(NSString *)key;

- (NSURL *)encodedFileURLForKey:(NSString *)key;

- (NSString *)keyForEncodedFileURL:(NSURL *)url;

- (NSString *)encodedString:(NSString *)string;
- (NSString *)decodedString:(NSString *)string;

@end
