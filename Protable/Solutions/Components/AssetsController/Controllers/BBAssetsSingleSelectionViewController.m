//
//  UIAssetsSingleSelectViewController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-26.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBAssetsSingleSelectionViewController.h"
#import "BBImageGridCell.h"
#import "BBAssetsHelper.h"
#import "BBStandardCameraManager.h"

static NSString* kCellID = @"cell_lalzkzkausd8f";

@interface BBAssetsSingleSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BBStandardCameraManagerDelegate> {
    UICollectionView *_collectionView;
    
    BBStandardCameraManager *_cameraManager;
}


@end

@implementation BBAssetsSingleSelectionViewController

- (id)init
{
    self = [super init];
    if (self) {
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

    self.view.backgroundColor = SKIN_COLOR(@"page_view_background");
    self.navigationItem.title = @"全部照片";
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    [self loadSavedPhotos];
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
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.allowsMultipleSelection = NO;
        [_collectionView registerClass:[BBImageGridCell class] forCellWithReuseIdentifier:kCellID];
        [self.view addSubview:_collectionView];
        
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//            _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);    // top:PHONE_NAVIGATIONBAR_HEIGHT + PHONE_STATUSBAR_HEIGHT
//        }
    }
    [_collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel
{
    [self.delegate assetsSingleSelectViewControllerWillCancel:self];
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

#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[BBAssetsHelper sharedInstance].assetPhotos count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BBImageGridCell *cameraButtonCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
        [cameraButtonCell setImage:SKIN_IMAGE(@"take_photo")];
        return cameraButtonCell;
    } else {
        BBImageGridCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
        ALAsset *asset = [[BBAssetsHelper sharedInstance] getAssetAtIndex:indexPath.row - 1];
        [photoCell setImage:[BBAssetsHelper getImageFromAsset:asset type:BBAssetsHelperPhotoSizeTypeThumbnail]];
        return photoCell;
    }
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
    if (indexPath.row == 0) {
        [self onShowCamera];
    } else {
        ALAsset *asset = [[BBAssetsHelper sharedInstance] getAssetAtIndex:indexPath.row - 1];
        [self.delegate assetsSingleSelectViewController:self willComplete:asset];
        
        [self dismiss];
    }
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
    [self dismiss];
    
    [self.delegate assetsSingleSelectViewController:self cameraComplete:asset];
}

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
