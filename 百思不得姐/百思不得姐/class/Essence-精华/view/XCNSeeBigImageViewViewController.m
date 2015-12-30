//
//  XCNSeeBigImageViewViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/22.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNSeeBigImageViewViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCNTopic.h"
#import <SVProgressHUD.h>
#import <AssetsLibrary/AssetsLibrary.h>// iOS9开始完全废弃
#import <Photos/Photos.h> // iOS8开始使用
@interface XCNSeeBigImageViewViewController ()
/** 图片 */
@property(nonatomic, weak) UIImageView *imgView;
@end

@implementation XCNSeeBigImageViewViewController
  static NSString * const XCNConllectionName = @"百思不得姐";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加scrollView
  
    UIScrollView *scrollView = [[UIScrollView alloc]init];

    scrollView.frame = [UIScreen mainScreen].bounds;
    // 添加到最下面
    [self.view insertSubview:scrollView atIndex:0];
    // 添加imageView
    UIImageView *imgView = [[UIImageView alloc]init];
    [scrollView addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.topic.big_image]];
    imgView.width = scrollView.width;
    imgView.height = self.topic.height * imgView.width /self.topic.width;
//    XCNLog(@"%f,%f",self.topic.height,self.topic.width);
    imgView.x = 0;
    if (imgView.height>scrollView.height) {
        imgView.y = 0;
    }else
    {
        imgView.centerY = scrollView.height*0.5;
    }
    
    self.imgView = imgView;
    // 设置contentSize
    scrollView.contentSize = CGSizeMake(0, imgView.height);
    // 缩放比例
    CGFloat maxScale = self.topic.height/imgView.height;
    // 不让图片缩小,保持图片清晰度,只让图片放大
    if (maxScale>1.0) {
        scrollView.maximumZoomScale = maxScale;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
   // 判断状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {// 用户拒绝访问
        XCNLog(@"用户拒绝当前应用访问相册-提醒用户打开访问");
    }else if (status == PHAuthorizationStatusNotDetermined){// 用户还没有做出选择
        XCNLog(@"用户还没有做出选择");
        [self saveImage];
    }else if (status == PHAuthorizationStatusRestricted){// 家长控制
        XCNLog(@"家长控制-不允许访问");
    }else if(status == PHAuthorizationStatusAuthorized){// 用户同意
        [self saveImage];
    }
}
- (PHAssetCollection *)getCollection
{
    // 不管先前创建过没有相册,都遍历相册看是否创建过同名相册
    PHFetchResult *resualt = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum  subtype:PHAssetCollectionSubtypeAlbumRegular  options:0];
    for (PHAssetCollection *collection in resualt) {
        if ([collection.localizedTitle isEqualToString:XCNConllectionName]) {
            return collection;
        }
    }
    // 如果相册不存在就创建新的相册
    __block NSString *collectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId =[PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:XCNConllectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    //
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

- (void)saveImage
{
    /**
     PHAsset :代表一个资源,比如一张图片
     PHAssetCollection :代表一个相册对象
     */
    __block NSString *assetId = nil;
    // 1.存储图片到相册胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 创建一个PHAssetCreationRequest资源(图片)请求,从哪里创建资源请求:
        // 返回一个PHAsset资源的字符标示
      assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imgView.image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            XCNLog(@"保存图片到相机胶卷失败");
            return;
        }
        XCNLog(@"成功保存图片到相机胶卷中");
        // 2.获得相册对象
        PHAssetCollection *collection = [self getCollection];
        //    XCNLog(@"%@",collection);
        // 3.将相机胶卷中得具有一定标示的图片存入获得的相册对象
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 获得一个相册资源更换的请求的对象
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            // 根据唯一标示获取图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            // 将图片写入到相册中
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                XCNLog(@"添加图片到相册中失败");
                return;
            }
            XCNLog(@"成功添加图片到相册中");
            // 系统将图片写入相册是在子线程进行的所以要回主线程刷新
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }];
        }];

    }];
    }




















@end
