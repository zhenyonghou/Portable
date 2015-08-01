//
//  BBStandardCameraManager.m
//

#import "BBStandardCameraManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIImagePickerController.h>

@interface BBStandardCameraManager ()

@end

@implementation BBStandardCameraManager

- (id)init
{
    if (self = [super init]) {
        _cameraOrientation = BBStandardCameraOrientationRear;
    }

    return self;
}

- (void)showCameraInViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_pickerController) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            pickerController.delegate = self;
            if (_cameraOrientation == BBStandardCameraOrientationRear) {
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear; // 后置摄像头
            }
            else
            {
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront; // 前置摄像头
            }

            _pickerController = pickerController;
            _pickerController.view.backgroundColor = [UIColor blackColor];
        }
        [controller presentViewController:_pickerController animated:animated completion:nil];
    }
}

- (void)dismissCameraWithAnimated:(BOOL)animated
{
    [_pickerController dismissViewControllerAnimated:animated completion:^{
        _pickerController = nil;
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if( picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat max = kHDImageMaxLength;
        image = [UIImage scaleAndRotateImage:image size:max];
        
        
        __strong id<BBStandardCameraManagerDelegate> strongDelegate = self.delegate;
        if (strongDelegate && [strongDelegate respondsToSelector:@selector(cameraController:didFinishWithImage:)]) {
            [strongDelegate performSelector:@selector(cameraController:didFinishWithImage:) withObject:picker withObject:image];
        }
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSMutableDictionary *originMetadata = [info valueForKey:UIImagePickerControllerMediaMetadata];
        NSMutableDictionary *mutableMetadata = [NSMutableDictionary dictionary];
        if ([originMetadata objectForKey:@"{Exif}"]) {
            [mutableMetadata setValue:[originMetadata objectForKey:@"{Exif}"]  forKey:@"{Exif}"];
        }
        if ([originMetadata objectForKey:@"{TIFF}"]) {
            [mutableMetadata setValue:[originMetadata objectForKey:@"{TIFF}"]  forKey:@"{TIFF}"];
        }
        if ([originMetadata objectForKey:@"{GPS}"]) {
            [mutableMetadata setValue:[originMetadata objectForKey:@"{GPS}"]  forKey:@"{GPS}"];
        }

        [library writeImageToSavedPhotosAlbum:[image CGImage]
                                     metadata:mutableMetadata
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  if (!error) {
                                      if (strongDelegate && [strongDelegate respondsToSelector:@selector(cameraControllerDidFinishSaveMetaData:asset:error:)]) {
                                          [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                              [strongDelegate cameraControllerDidFinishSaveMetaData:picker asset:asset error:nil];
                                          } failureBlock:^(NSError *error) {
                                              [strongDelegate cameraControllerDidFinishSaveMetaData:picker asset:nil error:error];
                                          }];
                                      }
                                  }
                              }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __strong id<BBStandardCameraManagerDelegate> strongDelegate = self.delegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(cameraControllerDidCancel:)]) {
        [strongDelegate cameraControllerDidCancel:picker];
    }
}

@end
