//
//  ViewController.m
//  PhotoKitDemo
//
//  Created by 解梁 on 16/7/13.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ListViewController.h"
#import "CollectionViewCell.h"
#import "WaterfallLayout.h"
#import "BigImageViewController.h"
#import "Animator.h"

@interface ListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic, retain)NSMutableArray *dataSource;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, retain)WaterfallLayout *layout;
@property (nonatomic, retain)NSIndexPath *indexPath;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupPhotoDataSource];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Photo List";
    [self.view addSubview:self.collectionView];
    self.navigationController.delegate = self;
}

//PhotoKit 获取照片资源
- (void)setupPhotoDataSource
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    //按照时间 降序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //获取全部照片资源
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    for (NSInteger j = 0; j < allPhotos.count; j++) {
        // 获取一个资源（PHAsset）
        PHAsset *asset = allPhotos[j];
        [self.dataSource addObject:asset];
    }
    self.layout.dataSource = self.dataSource;
    [self.collectionView reloadData];
}

#pragma mark - Animator

//返回转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return nil;
    }
    Animator *animator = [[Animator alloc]init];
    animator.rect = [self.collectionView convertRect:[self.collectionView layoutAttributesForItemAtIndexPath:self.indexPath].frame toView:self.view];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:self.dataSource[self.indexPath.item] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        animator.image = result;
    }];
    return animator;
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellId" forIndexPath:indexPath];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    [[PHImageManager defaultManager] requestImageForAsset:self.dataSource[indexPath.item] targetSize:CGSizeMake((kWidth -(kColumnNum + 1)*kColumnPadding)/kColumnNum, (kWidth - (kColumnNum + 1)*kColumnPadding)/kColumnNum * [self.dataSource[indexPath.item] pixelHeight]/[self.dataSource[indexPath.item] pixelWidth]) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.imageView.image = result;
    }];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kColumnPadding, kColumnPadding, kColumnPadding, kColumnPadding);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    BigImageViewController *bigImageViewController = [[BigImageViewController alloc]init];
    bigImageViewController.indexPath = indexPath;
    bigImageViewController.dataSource = self.dataSource;
    [self.navigationController pushViewController:bigImageViewController animated:YES];
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _collectionView;
}

- (WaterfallLayout *)layout
{
    if (_layout == nil) {
        _layout = [[WaterfallLayout alloc]init];
        _layout.minimumLineSpacing = kColumnPadding;
        _layout.minimumInteritemSpacing = kColumnPadding;
    }
    return _layout;
}

@end
