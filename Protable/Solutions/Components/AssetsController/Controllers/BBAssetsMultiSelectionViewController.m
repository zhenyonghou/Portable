//
//  BBAssetsMultiSelectionViewController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBAssetsMultiSelectionViewController.h"
#import "BBImageEnableSelectGridCell.h"
#import "UIImage+Protable.h"
#import "BBAssetsHelper.h"
#import "BBImageGridCell.h"
#import "BBStandardCameraManager.h"
#import "ALAsset+Compare.h"

static NSString* kPhotoCellId = @"cell_laisdfausd8f";

@interface BBAssetsMultiSelectionViewController () <UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout
, BBSelectFlagGridCellDelegate
, BBStandardCameraManagerDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_selectedAssets;
    
    BBStandardCameraManager *_cameraManager;
}

@end

@implementation BBAssetsMultiSelectionViewController

- (id)initWithMaximumSelectCount:(NSInteger)maximumSelect
{
    self = [super init];
    if (self) {
        _selectedAssets = [[NSMutableArray alloc] init];
        _maximumSelect = maximumSelect;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplicationWillEnterForground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"全部照片"];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    NSString *confirmButtonTitle = [NSString stringWithFormat:@"确定(%lu)", (unsigned long)[_selectedAssets count]];
    UIBarButtonItem * confirmButton = [[UIBarButtonItem alloc] initWithTitle:confirmButtonTitle
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onConfirm)];
    self.navigationItem.rightBarButtonItem = confirmButton;

    [self loadSavedPhotos];
//    [self buildToolbar];
}

- (void)loadSavedPhotos
{
    [[BBAssetsHelper sharedInstance] getSavedPhotoList:^(NSArray *array) {
        [self buildCollectionView];
    } error:^(NSError *err) {
        NSLog(@"加载失败"); // TODO:
    }];
}

- (void)buildCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[BBImageEnableSelectGridCell class] forCellWithReuseIdentifier:kPhotoCellId];
        [self.view addSubview:_collectionView];
        
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
////            _collectionView.contentInset = UIEdgeInsetsMake(PHONE_NAVIGATIONBAR_HEIGHT + PHONE_STATUSBAR_HEIGHT, 0, PHONE_TOOLBAR_HEIGHT, 0);
//            _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        }
    }
    [_collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.toolbarHidden = YES;
}

//- (void)buildToolbar
//{
//    UIButton* completeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 52, 44 - 6)];
//    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
//    [completeButton.titleLabel setFont:FONT_MAIN(13)];
//    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//
//    [completeButton addTarget:self action:@selector(onComplete) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* completeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
//    
//    UIBarButtonItem *btnPlace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    NSArray* items = @[btnPlace, completeButtonItem];
//    
//    [self setToolbarItems:items];
//}

- (void)onCancel
{
    [self.delegate assetsMultiSelectViewControllerWillCancel:self];
    [self dismiss];
}

- (void)onPreview
{
    
}

- (void)onConfirm
{
    if ([_selectedAssets count] == 0) {
//        [ToastHUD showToast:@"你还没有选择照片哦"];
        return;
    }
    
    [self.delegate assetsMultiSelectViewController:self willComplete:_selectedAssets];
    [self dismiss];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onShowCamera
{
    _cameraManager = [[BBStandardCameraManager alloc] init];
    _cameraManager.delegate = self;

    [_cameraManager showCameraInViewController:self animated:YES];
}

#pragma mark- selectedAsset

- (NSArray*)selectedAssets
{
    return _selectedAssets;
}

- (BOOL)isSelectedAsset:(ALAsset*)asset
{
    __block BOOL isSelected = NO;
    [_selectedAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([asset isEqual:obj]) {
            isSelected = YES;
        }
    }];
    return isSelected;
}

- (NSInteger)indexOfAssetInSelectedArray:(ALAsset*)asset
{
    __block NSInteger find = NSNotFound;
    [_selectedAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([asset isEqual:obj]) {
            find = idx;
            *stop = YES;
        }
    }];
    return find;
}

- (void)removeAssetFromSelectedArrayAtIndex:(NSUInteger)index
{
    [self removeAssetFromSelectedArrayAtIndex:index refreshView:YES];
}

- (void)removeAssetFromSelectedArrayAtIndex:(NSUInteger)index refreshView:(BOOL)refreshView
{
    [_selectedAssets removeObjectAtIndex:index];
    
    if (refreshView) {
        [_collectionView reloadData];
    }
}

- (void)removeAssetFromSelectedArray:(ALAsset*)asset
{
    NSInteger index = [self indexOfAssetInSelectedArray:asset];
    if (index != NSNotFound) {
        [self removeAssetFromSelectedArrayAtIndex:index refreshView:NO];
    }
}

- (BOOL)hasReachesMaximumSelectValue
{
    if (_maximumSelect == 0) {
        return NO;
    }
    
    return ([_selectedAssets count] >= _maximumSelect);
}

#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[BBAssetsHelper sharedInstance].assetPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBImageEnableSelectGridCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellId forIndexPath:indexPath];
    ALAsset *asset = [[BBAssetsHelper sharedInstance] getAssetAtIndex:indexPath.row];
    [photoCell setImage:[BBAssetsHelper getImageFromAsset:asset type:BBAssetsHelperPhotoSizeTypeThumbnail]];
    [photoCell setSelectedFlag:[self isSelectedAsset:asset] animated:NO];
    photoCell.iconRightMargin = 3.0;
    photoCell.iconTopMargin = 3.0;
    photoCell.delegate = self;
    return photoCell;
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (SCREEN_WIDTH - 2 * 3) / 4;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBImageEnableSelectGridCell *photoCell = (BBImageEnableSelectGridCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    ALAsset *asset = [[BBAssetsHelper sharedInstance] getAssetAtIndex:indexPath.row];
    
    NSInteger indexOfFind = [self indexOfAssetInSelectedArray:asset];
    if (indexOfFind != NSNotFound) {
        [self removeAssetFromSelectedArrayAtIndex:indexOfFind refreshView:NO];
        [photoCell setSelectedFlag:NO animated:YES];
    } else {
        if ([self hasReachesMaximumSelectValue]) {
//            [ToastHUD showToast:[NSString stringWithFormat:@"最多只能选%i张图片哦", _maximumSelect]];
            return;
        }
        
        [_selectedAssets addObject:asset];
        [photoCell setSelectedFlag:YES animated:YES];
    }

    [self onAssetsSelectedCountChanged];
}

#pragma mark- XCSelectFlagGridCellDelegate

- (BOOL)touchedFlagGridCell:(BBSelectFlagGridCell*)selectFlagCell shouldChangeState:(BBSwitchButtonState)select
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:selectFlagCell];
    ALAsset *asset = [[BBAssetsHelper sharedInstance] getAssetAtIndex:indexPath.row];

    if (BBSwitchButtonStateOn == select) {
        if ([self hasReachesMaximumSelectValue]) {
//            [ToastHUD showToast:@"最多只能选%i张图片哦"];
            return NO;
        }
        [_selectedAssets addObject:asset];
    } else {
        [self removeAssetFromSelectedArray:asset];
    }
    
    [self onAssetsSelectedCountChanged];
    
    return YES;
}

- (void)onAssetsSelectedCountChanged
{
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确定(%lu)", (unsigned long)[_selectedAssets count]];
}

#pragma mark- XCStandardCameraManagerDelegate

- (void)cameraController:(UIViewController *)controller didFinishWithImage:(UIImage *)image
{
//    self.cameraManager.pickerController
    NSLog(@"%s", __func__);
}

- (void)cameraControllerDidCancel:(UIViewController *)controller
{
    [_cameraManager dismissCameraWithAnimated:NO];
}

- (void)cameraControllerDidFinishSaveMetaData:(UIViewController *)controller asset:(ALAsset*)asset error:(NSError *)error
{
    [_cameraManager dismissCameraWithAnimated:NO];
    
    [self refreshSavedPhotos];
    
    [self.delegate assetsMultiSelectViewController:self cameraComplete:asset];
}

#pragma mark- methods


#pragma mark- notification

- (void)onApplicationWillEnterForground:(NSNotification *)notification
{
    [self refreshSavedPhotos];
}

- (void)refreshSavedPhotos
{
    [self loadSavedPhotos];
}

@end
