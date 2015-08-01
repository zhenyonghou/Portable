//
//  ALAsset+Compare.m


#import "ALAsset+Compare.h"
#import <ImageIO/ImageIO.h>

@implementation ALAsset (Compare)

// 图片资源唯一的标示
- (NSString *)uniqueId
{
    return [NSString stringWithFormat:@"%@%f", [self uniqueFileName], [self timeIntervalSince1970]];
}

// 比较两个图片资源指向的对象是否相等
- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    if (self.timeIntervalSince1970 == ((ALAsset *)other).timeIntervalSince1970) { // 比较拍摄时间
        NSString* selfUniqueFileName = self.uniqueFileName;
        NSString* otherUniqueFileName = ((ALAsset *)other).uniqueFileName;
        return [selfUniqueFileName isEqualToString:otherUniqueFileName];     // 比较文件名
    }
    
    return NO;
}

// 唯一图片资源的文件名
- (NSString *)uniqueFileName
{
    NSString *path = [self defaultRepresentation].url.relativeString;
    NSArray  *pathList = [path componentsSeparatedByString: @"/"];
    NSString *filteName = (NSString *)[pathList lastObject];
    return filteName;
}

// 图片属性日期
- (NSDate *)propertyDate
{
    NSDate * date = [self valueForProperty:ALAssetPropertyDate];
    return [date copy];
}

// 图片资源的拍摄时间
- (NSTimeInterval)timeIntervalSince1970
{
    NSDate * date = [self valueForProperty:ALAssetPropertyDate];
    return [date timeIntervalSince1970];
}

@end


@implementation ALAsset (Image)

// 获取原始图片
- (UIImage *)fullSizeImage
{
    return [self imageForMaxSize:kHDImageMaxLength];
}

// 获取缩略图
- (UIImage *)thumbnailSizeImage
{
    CGFloat screenSize = [UIScreen mainScreen].bounds.size.width * 0.3;
    return [self imageForMaxSize:screenSize];
}

// 获取全屏尺寸的照片
- (UIImage *)fullScreenImage
{
    return [UIImage imageWithCGImage:[self.defaultRepresentation fullScreenImage]];
}

#pragma mark - private methods

// 获取maxSize大小的图片
- (UIImage *)imageForMaxSize:(CGFloat)maxSize
{
    ALAssetRepresentation *assetRepresentation = self.defaultRepresentation;
    if ([assetRepresentation.metadata objectForKey:@"AdjustmentXMP"]) {
        //解析图片裁剪信息，发送的时候需要手动兼容，系统相机的裁剪，以便发送裁剪之后的图片
        //不如直接久返回屏幕大小的图片不会有影响用户体验，否则解析AdjustmentXMPH比较麻烦
        return [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
    }
    
    return [self originImageForMaxSize:maxSize];
}

// 根据maxSize裁剪图片大小
- (UIImage *)originImageForMaxSize:(CGFloat)maxSize
{
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    ALAsset *asset = self;
    ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
    UIImage *result = nil;
    NSData *data = nil;
    
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*[assetRepresentation size]);
    if (buffer != NULL) {
        NSError *error = nil;
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:0 length:[assetRepresentation size] error:&error];
        data = [NSData dataWithBytes:buffer length:bytesRead];
        if (error) {
            // DDLogInfo(@"读取照片错误 %@",error.localizedDescription);
        }
        free(buffer);
    }
    
    if ([data length]) {
        CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:(id)kCFBooleanTrue
                    forKey:(id)kCGImageSourceShouldAllowFloat];
        [options setObject:(id)kCFBooleanTrue
                    forKey:(id)kCGImageSourceCreateThumbnailFromImageAlways];
        
        CGFloat width;
        CGFloat height;
        CGSize size = CGSizeZero;
        if ([assetRepresentation respondsToSelector:@selector(dimensions)]) {
            size = [assetRepresentation dimensions];
        }else{
            size = [UIImage imageSizeWithData:data];
        }
        width = size.width;
        height = size.height;
        
        CGFloat newHeight = maxSize;
        CGFloat newWidth = maxSize;
        //超宽和超长图片需要放宽最大限制
        if (width / height >= kSuperImageRatio || height / width >= kSuperImageRatio) {
            if (width > kHDImageMaxLength) {
                newWidth = kHDImageMaxLength;
                newHeight = height / width * newWidth;
            }else{
                newWidth = width;
                newHeight = height;
            }
        }
        //最大的长图高度10240防止上传超大图片
        if (newHeight > kHDImageMaxHeight) {
            newHeight = kHDImageMaxHeight;
            newWidth =  newHeight * width / height ;
        }
        
        //设置最大的读入图片大小
        CGFloat newMaxSize = MAX(newHeight, newWidth);
        [options setObject:(id)[NSNumber numberWithFloat:newMaxSize]
                    forKey:(id)kCGImageSourceThumbnailMaxPixelSize];
        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef,
                                                                  0,
                                                                  (__bridge CFDictionaryRef)options);
        if (imageRef) {
            result = [UIImage imageWithCGImage:imageRef
                                         scale:[assetRepresentation scale]
                                   orientation:(UIImageOrientation)[assetRepresentation orientation]];
            CGImageRelease(imageRef);
        }
        
        if (sourceRef) CFRelease(sourceRef);
    }
//    DDLogInfo(@"读入的原始图片大小为：%@",NSStringFromCGSize(result.size));
    time = [[NSDate date] timeIntervalSince1970] - time;
//    DDLogInfo(@"maxSize %f 图片读入的时间为 %f",maxSize,time);
    return result;
}

@end
