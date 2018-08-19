//
//  StaticPictureController.m
//  LearningGPUImage
//
//  Created by eamon on 2018/8/17.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

#import "StaticPictureController.h"
#import "GPUImage.h"
#import "StaticPictureCell.h"
#import "UIView+Frame.h"

typedef NS_ENUM(NSInteger, ImageFilterType) {
    
    ImageFilterNone = 0,                 // 默认
    ImageFilterTypeVignette,             // 中间突出，四周暗
    ImageFilterTypeRGB,                  // RGB
    ImageFilterTypeSepia,                // 怀旧
    ImageFilterTypeHaze,                 // 朦胧加暗
    ImageFilterTypeSaturation,           // 饱和度
    ImageFilterTypeBrightness,           // 亮度
    ImageFilterTypeExposure,             // 曝光度
    ImageFilterTypeSketch,               // 素描
    ImageFilterTypeSmoothToon,           // 卡通
};



@interface StaticPictureController ()<UICollectionViewDelegate, UICollectionViewDataSource>

// collectionView
@property(nonatomic, strong) UICollectionView *collectionView;

// contentView
@property(nonatomic, strong) UIImageView *imageView;

// dataSource
@property(nonatomic, strong) NSArray *images;

@end

@implementation StaticPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)images {
    
    if (!_images) {
        
        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
            
            NSMutableArray *temps = @[].mutableCopy;
            UIImage *normal = [UIImage imageNamed:@"origin"];
            
            for (int i = 0; i < 10; i++) {
                
                UIImage *image = [self imageFilterWithType:i image:normal];
                NSString *title = [self titleWithType:i];
                
                NSMutableDictionary *dic = @{}.mutableCopy;
                [dic setObject:image forKey:@"image"];
                [dic setObject:title forKey:@"title"];
                [temps addObject:dic];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.images = temps;
                [self.collectionView reloadData];
            });
        });
    }
    
    return _images;
}

#pragma makr - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StaticPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.image = [_images[indexPath.row] objectForKey:@"image"];
    cell.title = [_images[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *currImage = [_images[indexPath.row] objectForKey:@"image"];
    self.imageView.image = currImage;
}

#pragma mark - Getter | Setter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"origin"]];
        _imageView.frame = CGRectMake(10, 64, self.view.width-20, self.view.height-64-100);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(100, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.height-100, self.view.width, 100) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StaticPictureCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    return _collectionView;
}

- (UIImage *) imageFilterWithType:(ImageFilterType) type image: (UIImage *) image {
    
    GPUImageOutput *filter;
    
    switch (type) {
        case ImageFilterNone:
            return image;
            break;
        case ImageFilterTypeVignette: {
            
            filter = [[GPUImageVignetteFilter alloc] init];
            break;
        }
            
        case ImageFilterTypeRGB: {
            
            filter = [[GPUImageRGBFilter alloc] init];
            // 改变RGB的值
            [(GPUImageRGBFilter *)filter setRed:0.8];
            [(GPUImageRGBFilter *)filter setGreen:0.6];
            [(GPUImageRGBFilter *)filter setBlue:0.7];
            
            break;
        }
            
        case ImageFilterTypeSepia: {
            
            filter = [[GPUImageSepiaFilter alloc] init];
            break;
        }
            
        case ImageFilterTypeHaze: {
            
            filter = [[GPUImageHazeFilter alloc] init];
            break;
        }
            
        case ImageFilterTypeSaturation: {
            
            filter = [[GPUImageSaturationFilter alloc] init];
            [(GPUImageSaturationFilter *)filter setSaturation:1.5];
            
            break;
        }
            
        case ImageFilterTypeBrightness: {
            
            filter = [[GPUImageBrightnessFilter alloc] init];
            [(GPUImageBrightnessFilter *)filter setBrightness:0.2];
            break;
        }
            
        case ImageFilterTypeExposure: {
            
            filter = [[GPUImageExposureFilter alloc] init];
            [(GPUImageExposureFilter *)filter setExposure:0.2];
            break;
        }
            
        case ImageFilterTypeSketch: {
            
            filter = [[GPUImageSketchFilter alloc] init];
            break;
        }
            
        case ImageFilterTypeSmoothToon: {
            
            filter = [[GPUImageSmoothToonFilter alloc] init];
            [(GPUImageSmoothToonFilter *)filter setBlurRadiusInPixels:0.2];
            break;
        }
        default:
            break;
    }
    
    // 渲染的区域
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    
    // 获取数据源
    GPUImagePicture *source = [[GPUImagePicture alloc] initWithImage:image];
    [source addTarget:filter];
    // 开始渲染
    [source processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

- (NSString *) titleWithType: (ImageFilterType) type {
    switch (type) {
        case ImageFilterNone:
            return @"默认";
        case ImageFilterTypeVignette:
            return @"晕影";
        case ImageFilterTypeRGB:
            return @"RGB";
        case ImageFilterTypeSepia:
            return @"怀旧";
        case ImageFilterTypeHaze:
            return @"朦胧";
        case ImageFilterTypeSaturation:
            return @"饱和度";
        case ImageFilterTypeBrightness:
            return @"亮度";
        case ImageFilterTypeExposure:
            return @"曝光度";
        case ImageFilterTypeSketch:
            return @"素描";
        case ImageFilterTypeSmoothToon:
            return @"卡通";
    }
}

@end
