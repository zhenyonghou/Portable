//
//  ALAsset+Compare.h


#import <AssetsLibrary/AssetsLibrary.h>

/**
 * @brief 图片资源比较类别
 */
@interface ALAsset (Compare)

/**
 * @brief 比较两个图片资源指向的对象是否相等
 * @param other 其他的图片资源
 * @returns YES 相等，否则 NO
 */
- (BOOL)isEqual:(id)other;

/**
 * @brief 图片资源唯一的标示
 * @returns 唯一的图片资源id
 */
- (NSString *)uniqueId;

/**
 * @brief 图片资源的拍摄时间
 * @returns 拍摄时间
 */
- (NSTimeInterval)timeIntervalSince1970;

@end

/**
 * @brief 获取图片资源相应的图片
 */
@interface ALAsset (Image)

/**
 * @brief 获取原始图片
 * @returns 原始图片
 */
- (UIImage *)fullSizeImage;

/**
 * @brief 获取全屏尺寸的照片
 * @returns 全屏尺寸的照片
 */
- (UIImage *)fullScreenImage;

/**
 * @brief 获取缩略图
 * @returns 缩略图
 */
- (UIImage *)thumbnailSizeImage;

@end