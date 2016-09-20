//
//  HandleView.m
//  画板
//
//  Created by chavez on 16/9/9.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "HandleView.h"

@interface HandleView ()<UIGestureRecognizerDelegate>
@property (nonatomic,weak) UIImageView *imageV;

@end

@implementation HandleView

- (UIImageView *)imageV{
    if (_imageV == nil) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.userInteractionEnabled = YES;
        _imageV = imageV;
        [self addSubview:imageV];
        // 添加手势
        [self addGes];
    }
    return _imageV;
}

- (void)addGes{
    // 添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];

    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.imageV addGestureRecognizer:pinch];


    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longP:)];
    [self.imageV addGestureRecognizer:longP];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    // 复位
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    [pinch setScale:1];
}

- (void)longP:(UILongPressGestureRecognizer *)longP{
    if (longP.state == UIGestureRecognizerStateBegan) {
        
        // 先让图片闪一下，把图片绘制到画板当中
        [UIView animateWithDuration:0.5 animations:^{
            longP.view.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                longP.view.alpha = 1;
            }completion:^(BOOL finished) {
                //  把图片绘制到画板当中 截屏
                UIGraphicsBeginImageContextWithOptions(longP.view.bounds.size, NO, 0);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                
                UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
                // 调用代理方法
                if (_delegate && [_delegate respondsToSelector:@selector(handleImageVIew:image:)]) {
                    [_delegate handleImageVIew:self image:newImage];
                }
                

            }];
            
            
        }];
        
    }
}


- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageV.image = image;
}

@end
