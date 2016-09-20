//
//  CWFoldViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/20.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWFoldViewController.h"

@interface CWFoldViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@end

@implementation CWFoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.让上不图片只显示上半部分
    self.topImageV.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    // 2.让下部分图片只显示下半部分
    self.bottomImageV.layer.contentsRect = CGRectMake(0, 0.5, 1,0.5);
    
    self.topImageV.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomImageV.layer.anchorPoint = CGPointMake(0.5, 0);
    
    //渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bottomImageV.bounds;
    // 设置渐变的颜色
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    // 设置渐变透明
    gradientLayer.opacity = 0;
    
    [self.bottomImageV.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
}

// 渐变曾
- (void)gradientLayer1{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bottomImageV.bounds;
    // 设置渐变的颜色
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor blueColor].CGColor];
    // 设置渐变的方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    // 设置一个渐变到另一个渐变的起始位置
    gradientLayer.locations = @[@0.3,@0.5];
    [self.bottomImageV.layer addSublayer:gradientLayer];
}


- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    
    //  获取移动的偏移量
    CGPoint transP = [pan translationInView:pan.view];
    // 让上部图片开始旋转
    CGFloat angle = transP.y * M_PI / 200;
    
    // 近大远小的效果
    CATransform3D transform = CATransform3DIdentity;
    // 800代表眼睛离屏幕的距离，越小 眼睛距离屏幕越近
    transform.m34 = -1.0/800;
    
    self.gradientLayer.opacity = transP.y * 1 / 200.0;
    
    
    //self.topImageV.layer.transform = CATransform3DMakeRotation(-angle, 1, 0, 0);
    self.topImageV.layer.transform = CATransform3DRotate(transform, -angle, 1, 0, 0);
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        self.gradientLayer.opacity = 0;
        
        // usingSpringWithDamping 弹性系数，越小弹性越大  initialSpringVelocity：初始的弹性速度
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            // 上部的图片复位
            self.topImageV.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}



@end
