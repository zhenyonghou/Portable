//
//  UIImage+Additions.m
//
//  Created by houzhenyong on 14-3-15.
//
#import <ImageIO/ImageIO.h>
#import "UIImage+BAAdditions.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

const CGFloat kSuperImageRatio          = 2.9f;         // 超宽和超长图片的最大比例
const CGFloat kHDImageMaxHeight         = 12040.0f;     // 高清图片最大的高度
const CGFloat kHDImageMaxLength         = 1204.0f;      // 高清图片最大的长度（长度和宽度）
const CGFloat kNormalImageMaxLength     = 900.0f;       // 普通图片最大的长度 (长度和宽度)
const CGFloat kImageCompressionValue    = 0.8f;         // 图片上传的压缩比例

@implementation UIImage (BAAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [[self class] imageWithColor:color imageSize:CGSizeMake(1, 1)];
}

+ (UIImage*)resizeFromCenterWithImage:(UIImage*)image
{
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
}

- (UIImage*)blurredImage:(CGFloat)blurAmount
{
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (!error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


// 从ALAssetRepresentation内获取图片大小
+ (CGSize)imageSizeWithData:(NSData *)data
{
    CGSize imageSize = CGSizeZero;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);
    if (source)
    {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCGImageSourceShouldCache];
        
        NSDictionary *properties = (__bridge_transfer NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, (__bridge CFDictionaryRef) options);
        
        if (properties)
        {
            NSNumber *width = [properties objectForKey:(NSString *)kCGImagePropertyPixelWidth];
            NSNumber *height = [properties objectForKey:(NSString *)kCGImagePropertyPixelHeight];
            if ((width != nil) && (height != nil))
                imageSize = CGSizeMake(width.floatValue, height.floatValue);
        }
        CFRelease(source);
    }
    
    return imageSize;
}

// 向右旋转角度
+ (UIImage *)rotateRightWithImage:(UIImage *)image degree:(CGFloat)degree
{
    CGFloat radian = degreesToRadians(degree);
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radian);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, radian);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2,
                                          -image.size.height / 2,
                                          image.size.width,
                                          image.size.height),
                       [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 纠正图片的方向
+ (UIImage *)correctOrientationWithImage:(UIImage *)image
{
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0, image.size.width, image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

// 根据图片的方向进行旋转照片
//+ (UIImage *)rotateImage:(UIImage *)image withOrientation:(UIImageOrientation)orient
//{
//    CGRect             bnds = CGRectZero;
//    UIImage*           copy = nil;
//    CGContextRef       ctxt = nil;
//    CGRect             rect = CGRectZero;
//    CGAffineTransform  tran = CGAffineTransformIdentity;
//    
//    bnds.size = image.size;
//    rect.size = image.size;
//    
//    switch (orient)
//    {
//        case UIImageOrientationUp:
//            return image;
//            
//        case UIImageOrientationUpMirrored:
//            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            break;
//            
//        case UIImageOrientationDown:
//            tran = CGAffineTransformMakeTranslation(rect.size.width,
//                                                    rect.size.height);
//            tran = CGAffineTransformRotate(tran, [COImageUtility degreeToRadian:180.0]);
//            break;
//            
//        case UIImageOrientationDownMirrored:
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
//            tran = CGAffineTransformScale(tran, 1.0, -1.0);
//            break;
//            
//        case UIImageOrientationLeft:
//            bnds.size = [COImageUtility swapWidthAndHeightWithImageSize:bnds.size];
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
//            tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//            bnds.size = [COImageUtility swapWidthAndHeightWithImageSize:bnds.size];
//            tran = CGAffineTransformMakeTranslation(rect.size.height,
//                                                    rect.size.width);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
//            break;
//            
//        case UIImageOrientationRight:
//            bnds.size = [COImageUtility swapWidthAndHeightWithImageSize:bnds.size];
//            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
//            tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
//            break;
//            
//        case UIImageOrientationRightMirrored:
//            bnds.size = [COImageUtility swapWidthAndHeightWithImageSize:bnds.size];
//            tran = CGAffineTransformMakeScale(-1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
//            break;
//            
//        default:
//			// orientation value supplied is invalid
//            assert(false);
//            return nil;
//    }
//    
//    UIGraphicsBeginImageContext(bnds.size);
//    ctxt = UIGraphicsGetCurrentContext();
//    
//    switch (orient)
//    {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            CGContextScaleCTM(ctxt, -1.0, 1.0);
//            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
//            break;
//            
//        default:
//            CGContextScaleCTM(ctxt, 1.0, -1.0);
//            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
//            break;
//    }
//    
//    CGContextConcatCTM(ctxt, tran);
//    CGContextDrawImage(ctxt, rect, image.CGImage);
//    
//    copy = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return copy;
//}

+ (UIImage *)cutIntoImageToSquare:(UIImage *)image
{
    UIImage *scaledImage = image;
    if(scaledImage.size.height == scaledImage.size.width){
        return scaledImage;
    }
    
    CGRect subImageRect = CGRectZero;
    if (image.size.height > scaledImage.size.width) {
        subImageRect= CGRectMake(0,
                                 0,
                                 scaledImage.size.width,
                                 image.size.width);
    } else {
        subImageRect= CGRectMake((scaledImage.size.width - scaledImage.size.height)/2,
                                 0,
                                 scaledImage.size.height,
                                 scaledImage.size.height);
    }
    CGImageRef imageRef =scaledImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    scaledImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return scaledImage;
}


+ (UIImage *)rotateToOrientationUpImage:(UIImage *)image
{
    int width = image.size.width;
    int height = image.size.height;
    CGSize size = CGSizeMake(width, height);
    
    CGRect imageRect;
    
    if(image.imageOrientation==UIImageOrientationUp
       || image.imageOrientation==UIImageOrientationDown)
    {
        imageRect = CGRectMake(0, 0, width, height);
    }
    else
    {
        imageRect = CGRectMake(0, 0, height, width);
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if(image.imageOrientation==UIImageOrientationLeft)
    {
        CGContextRotateCTM(context, M_PI / 2);
        CGContextTranslateCTM(context, 0, -width);
    }
    else if(image.imageOrientation==UIImageOrientationRight)
    {
        CGContextRotateCTM(context, - M_PI / 2);
        CGContextTranslateCTM(context, -height, 0);
    }
    else if(image.imageOrientation==UIImageOrientationUp)
    {
        //DO NOTHING
    }
    else if(image.imageOrientation==UIImageOrientationDown)
    {
        CGContextTranslateCTM(context, width, height);
        CGContextRotateCTM(context, M_PI);
    }
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGContextRestoreGState(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (img);
}

+ (UIImage*)cropImage:(UIImage *)originalImage toRect:(CGRect)rect
{
    if (!originalImage) {
        return nil;
    }

    CGImageRef imageRef = originalImage.CGImage;
    if (!imageRef) {
        imageRef = [[self class] imageFromCIImage:originalImage.CIImage].CGImage;
    }

    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    CGImageRelease(subImageRef);
    return smallImage;
}

+ (UIImage*)imageFromCIImage:(CIImage*)ciImage {
    CGSize size = ciImage.extent.size;
    UIGraphicsBeginImageContext(size);
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size   = size;
    UIImage *remImage = [UIImage imageWithCIImage:ciImage];
    [remImage drawInRect:rect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    remImage = nil;
    ciImage = nil;
    //
    return result;
}

+ (UIImage *)scaleImage:(UIImage *)image withMaxSideLength:(CGFloat)length
{
    //SDLog("image.size.width: %f, image.size.height: %f, length: %f", image.size.width, image.size.height, length);
    
    if(length <= 0 || (image.size.width <= length + 5 && image.size.height <= length + 5))
    {
        return image;
    }
    
    CGFloat rate = MIN(length / image.size.width, length / image.size.height);
    CGSize size = CGSizeMake((int)(image.size.width * rate), (int)(image.size.height * rate));
    return [UIImage scaleImage:image toSize:size];
}

+ (UIImage *)scaleImage:(UIImage *)sourceImage toSize:(CGSize)targetSize
{
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

+ (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)rotateImage:(UIImage *)image radians:(CGFloat)radians
{
    return [[self class] rotateImage:image degrees:radiansToDegrees(radians)];
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image size:(NSInteger)size
{
    int kMaxResolution = size; // Or whatever
    
    CGFloat image_width = image.size.width;
    CGFloat image_height = image.size.height;
    
    //1 处理超长超宽图
    if (image_width >= kSuperImageRatio*image_height
        || image_height >= kSuperImageRatio*image_width) {
        if (image_width > image_height && image_height >= size) {
            kMaxResolution = image_width/image_height*size;
        }else if(image_height > image_width && image_width >= size){
            kMaxResolution = image_height/image_width*size;
        }else{
            kMaxResolution = image_width > image_height ? image_width : image_height;
        }
    }
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: // EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: // EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: // EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: // EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: // EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: // EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: // EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: // EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
