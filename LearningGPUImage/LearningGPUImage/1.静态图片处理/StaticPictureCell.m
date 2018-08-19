//
//  StaticPictureCell.m
//  LearningGPUImage
//
//  Created by eamon on 2018/8/18.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

#import "StaticPictureCell.h"

#import "UIView+Frame.h"

@interface StaticPictureCell()

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation StaticPictureCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}


- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"origin"];
    }
    
    return _imageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-40, self.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

@end
