//
//  BageVlaueBtn.m
//  QQ粘性布局
//
//  Created by chavez on 16/9/13.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "BageVlaueBtn.h"

@interface BageVlaueBtn ()
@property (nonatomic,weak) UIView *smallCircle;
@property (nonatomic,weak) CAShapeLayer *shapL;

@end

@implementation BageVlaueBtn

- (CAShapeLayer *)shapL{
    if (_shapL == nil) {
        CAShapeLayer *shapL = [CAShapeLayer layer];
        [self.superview.layer insertSublayer:shapL atIndex:0];
        shapL.fillColor = [UIColor redColor].CGColor;
        _shapL = shapL;
    }
    return _shapL;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    [self setUp];
    

    
    // 添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)setUp{
    // 圆角
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    // 设置背景颜色
    [self setBackgroundColor:[UIColor redColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // 添加小圆
    UIView *smallCircle = [[UIView alloc] initWithFrame:self.frame];
    smallCircle.layer.cornerRadius = self.layer.cornerRadius;
    smallCircle.backgroundColor = self.backgroundColor;
    self.smallCircle = smallCircle;
    [self.superview addSubview:smallCircle];
    
    [self.superview insertSubview:smallCircle belowSubview:self];
    
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    // 拖动
    CGPoint transP = [pan translationInView:self];
    // transform并没有修改center，修改的是frame
//    self.transform = CGAffineTransformTranslate(self.transform, transP.x, transP.y);
    CGPoint center = self.center;
    center.x += transP.x;
    center.y += transP.y;
    self.center = center;
    // 复位
    [pan setTranslation:CGPointZero inView:self];
    
    CGFloat distance = [self distanceWithSmallCircle:self.smallCircle BigCircle:self];
    
    // 让小圆的半径根据距离的增大，半径减小
    CGFloat smallR = self.bounds.size.width/2;
    smallR -= distance / 10.0;
    self.smallCircle.bounds = CGRectMake(0, 0, smallR * 2, smallR * 2);
    self.smallCircle.layer.cornerRadius = smallR;
    
    
    // 形状图层
    if (self.smallCircle.hidden == NO) {
        UIBezierPath * path = [self pathWithSmallCircle:self.smallCircle bigCircle:self];
        self.shapL.path = path.CGPath;
    }
    
    if (distance > 60) {
        // 让小圆隐藏，让路径隐藏
        self.smallCircle.hidden = YES;
//        self.shapL.hidden = YES; 带隐式动画
        [self.shapL removeFromSuperlayer];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 判断结束时距离是否大于60
        // 大于60让按钮消失
        // 小于60 复位
        if (distance < 60) {
            [self.shapL removeFromSuperlayer];
            self.center = self.smallCircle.center;
            self.smallCircle.hidden = NO;
        }else{
            // 播放一个动画消失
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i = 1; i <= 8; i++) {
                UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",i]];
                [imageArray addObject:image];
            }
            imageV.animationImages = imageArray;
            imageV.animationDuration = 1;
            [imageV startAnimating];
            
            [self addSubview:imageV];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
        }
    }
    
}

// 给定两个圆，描述一个不规则的路径
- (UIBezierPath *)pathWithSmallCircle:(UIView *)smallCircle bigCircle:(UIView *)bigCircle{
    CGFloat x1 = smallCircle.center.x;
    CGFloat y1 = smallCircle.center.y;
    
    CGFloat x2 = bigCircle.center.x;
    CGFloat y2 = bigCircle.center.y;
    
    CGFloat d = [self distanceWithSmallCircle:smallCircle BigCircle:bigCircle];
    
    if (d <= 0) {
        return nil;
    }
    
    CGFloat cosΘ = (y2 - y1) / d;
    CGFloat sinΘ = (x2 - x1) / d;
    
    CGFloat r1 = smallCircle.bounds.size.width * 0.5;
    CGFloat r2 = bigCircle.bounds.size.width * 0.5;
    
    // 描述点
    // A
    CGPoint pointA = CGPointMake(x1 - r1 * cosΘ, y1 + r1 * sinΘ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosΘ, y1 - r1 * sinΘ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosΘ, y2 - r2 * sinΘ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosΘ, y2 + r2 * sinΘ);
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinΘ, pointA.y + d * 0.5 * cosΘ);
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinΘ, pointB.y + d * 0.5 * cosΘ);
    
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    //AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    //BC（曲线）
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //DA（曲线）
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}



// 求两个圆之间的距离
- (CGFloat)distanceWithSmallCircle:(UIView *)smallCircle BigCircle:(UIView *)bigCircle{
    // x偏移
    CGFloat offsetX = bigCircle.center.x - smallCircle.center.x;
    // y偏移
    CGFloat offsetY = bigCircle.center.y - smallCircle.center.y;
    
    return sqrt(offsetX * offsetX + offsetY * offsetY);
    
}


// 取消高亮状态
- (void)setHighlighted:(BOOL)highlighted{
    
}


@end
