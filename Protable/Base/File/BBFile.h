
#import <Foundation/Foundation.h>

@interface BBFile : NSObject

// 检查路径是否指向文件
+ (BOOL)isExistFileAtPath:(NSString *)path;
// 检查路径是否指向文件夹
+ (BOOL)isExistDirAtPath:(NSString *)path;
// 检查本地路径下是否存在某个文件
+ (BOOL)isExistFile:(NSString *)fileName atPath:(NSString *)path;
// 检查本地路径下是否存在某个文件夹
+ (BOOL)isExistDir:(NSString *)dirName atPath:(NSString *)path;


// 当前路径对应的那一级目录下，除文件夹之外的文件的大小
+ (unsigned long long)fileSizeWithInDirectFolderAtPath:(NSString *)path;
// 某个路径下所有文件的大小
+ (unsigned long long)totalFilesSizeAtPath:(NSString *)path;

// 检查是否文件夹大小到达上限
+ (BOOL)isArriveUpperLimitAtPaths:(NSArray *)paths withUpperLimitByByte:(unsigned long long)upperLimit;
+ (BOOL)isArriveUpperLimitAtPaths:(NSArray *)paths withUpperLimitByKByte:(unsigned long long)upperLimit;
+ (BOOL)isArriveUpperLimitAtPaths:(NSArray *)paths withUpperLimitByMByte:(unsigned long long)upperLimit;


// 在本地添加文件夹
+ (NSString *)createDir:(NSString *)path;
//  在本地目录下添加文件夹
+ (NSString *)createDir:(NSString *)dirName atPath:(NSString *)path;


// 在本地删除路径
+ (BOOL)deletePath:(NSString *)path;
+ (void)deletePaths:(NSArray *)paths;

@end
