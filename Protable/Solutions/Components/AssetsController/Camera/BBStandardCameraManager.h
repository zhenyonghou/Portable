//
//  BBStandardCameraManager.h
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, BBStandardCameraOrientation) {
    BBStandardCameraOrientationRear = 0,        // 后置摄像头
    BBStandardCameraOrientationFront            // 前置摄像头
};

@protocol BBStandardCameraManagerDelegate;


@interface BBStandardCameraManager : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, weak)id<BBStandardCameraManagerDelegate> delegate;
@property(nonatomic, assign)BBStandardCameraOrientation cameraOrientation;

@property(nonatomic, strong, readonly) UIImagePickerController *pickerController;

/**
 * @brief 启动照相机
 * @param controller 启动照相机的controller
 */
- (void)showCameraInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismissCameraWithAnimated:(BOOL)animated;

@end


@protocol BBStandardCameraManagerDelegate <NSObject>

@optional
- (void)cameraController:(UIViewController *)controller didFinishWithImage:(UIImage *)image;
- (void)cameraControllerDidCancel:(UIViewController *)controller;
- (void)cameraControllerDidFinishSaveMetaData:(UIViewController *)controller asset:(ALAsset*)asset error:(NSError *)error;

@end
