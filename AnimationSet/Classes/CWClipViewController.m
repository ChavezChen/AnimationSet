//
//  CWClipViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/7.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWClipViewController.h"



@interface CWClipViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,assign)CGPoint startP;
@property (nonatomic,weak) UIView *coverV;
@end

@implementation CWClipViewController

- (UIView *)coverV{
    if (_coverV == nil) {
        // 添加一个uiview
        UIView * coverV = [[UIView alloc] init];
        coverV.backgroundColor = [UIColor blackColor];
        coverV.alpha = 0.7;
        _coverV = coverV;
        [self.view addSubview:coverV];
    }
    return _coverV;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用左划返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启左划返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    CGPoint curP = [pan locationInView:self.imageView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startP = curP;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        CGFloat x = _startP.x;
        CGFloat y = _startP.y;
        CGFloat w = curP.x-_startP.x;
        CGFloat h = curP.y-_startP.y;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.coverV.frame = rect;
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        // 把超过coverV的frame以外的内容裁剪掉
        
        // 生成一张图片，把原来的图片替换掉
        // 1.开启位图上下文  BOOL opaque 设置为NO 为透明 设置为YES为不透明
        UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0);
        
        // 2.把imageView绘制到上下文之前，设置一个裁剪区域
        UIBezierPath * clipPath = [UIBezierPath bezierPathWithRect:self.coverV.frame];
        [clipPath addClip];
        
        // 3.把当前的imageView渲染到上下文中
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageView.layer renderInContext:ctx];
        // 4.从上下文当中生成一张图片
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 5.关闭上下文
        UIGraphicsEndImageContext();
        self.imageView.image = newImage;
        
        // 移除遮盖
        [self.coverV removeFromSuperview];
    }

}

@end
