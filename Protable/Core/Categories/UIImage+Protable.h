//
//  UIImage+Additions.h
//
//  Created by houzhenyong on 14-3-15.
//

#import <UIKit/UIKit.h>

extern const CGFloat kSuperImageRatio;          // 超宽和超长图片的最大比例
extern const CGFloat kHDImageMaxHeight;         // 高清图片最大的高度 (超大图片)
extern const CGFloat kHDImageMaxLength;         // 高清图片最大的长度（长度和宽度）
extern const CGFloat kNormalImageMaxLength;     // 普通图片最大的长度 (长度和宽度)
extern const CGFloat kImageCompressionValue;    // 图片上传的压缩比例

@interface UIImage (Protable)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

+ (UIImage*)resizeFromCenterWithImage:(UIImage*)image;


- (UIImage*)blurredImage:(CGFloat)blurAmount;

/**
 * @brief 获取图片大小
 * @param data ALAssetRepresentation的data数据
 * @returns 图片大小
 */
+ (CGSize)imageSizeWithData:(NSData *)data;

/**
 * @brief 向右旋转一张照片
 * @param image 需要旋转的图片
 * @param degree 旋转的角度
 * @returns 旋转后的图片
 */
+ (UIImage *)rotateRightWithImage:(UIImage *)image degree:(CGFloat)degree;

/**
 * @brief 纠正图片的方向
 * @param image 原有的图片
 * @returns 纠正后的图片
 */
+ (UIImage *)correctOrientationWithImage:(UIImage *)image;

/**
 * @brief 根据图片的方向进行旋转照片
 * @param image 需要旋转的图片
 * @param orient 旋转的方向
 * @returns 旋转后的图片
 */
//+ (UIImage *)rotateImage:(UIImage *)image withOrientation:(UIImageOrientation)orient;

/**
 * @brief 将图片裁剪成正方形。
 *        如果是款图，则取中间部分的正方形；
 *        如果是长图，则取上部的正方形。
 * @param image 需要裁剪的图片
 * @returns 裁剪后的图片
 */
+ (UIImage *)cutIntoImageToSquare:(UIImage *)image;

// 相机拍的照片处理前先过此函数
+ (UIImage *)rotateToOrientationUpImage:(UIImage *)image;

// 截取部分图
+ (UIImage*)cropImage:(UIImage *)originalImage toRect:(CGRect)rect;

/**
 按照比例缩放
 */
+ (UIImage *)scaleImage:(UIImage *)image withMaxSideLength:(CGFloat)length;

// 缩放
+ (UIImage *)scaleImage:(UIImage *)sourceImage toSize:(CGSize)targetSize;

// 旋转
+ (UIImage *)rotateImage:(UIImage *)image radians:(CGFloat)radians;

+ (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees;

+ (UIImage*)imageFromCIImage:(CIImage*)ciImage;


+ (UIImage *)scaleAndRotateImage:(UIImage *)image size:(NSInteger)size;

+ (UIImage *)screenshot;

@end
