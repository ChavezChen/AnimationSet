//
//  CWChangeView.m
//  CWAnimation
//
//  Created by macmini on 16/5/19.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWChangeView.h"




static CGFloat const kAnimation1Duration = 0.5;
static CGFloat const kAnimation2Duration = 0.5;
static CGFloat const kAnimation3Duration = 5.0;
static CGFloat const kAnimation4Duration = 5.0;



static const CGFloat LineWidth = 100.0f;
static const CGFloat Radius = 100.0f;
static const CGFloat LineHeight = 8.0f;
static const CGFloat LineGapHeight = 20.0f;
static const CGFloat kAngle = 45;    // 三点曲线的角度大小
#define CenterPositionX self.frame.size.width/2
#define CenterPositionY self.frame.size.height/2

#define TopY CenterPositionY - LineGapHeight - LineHeight/2
#define BottomY CenterPositionY + LineGapHeight + LineHeight/2
#define Radians(x)  (M_PI * (x) / 180.0)   // 通过角度求弧度
@interface CWChangeView ()
@property (nonatomic,strong) CAShapeLayer * topLineLayer;
@property (nonatomic,strong) CAShapeLayer * changeLineLayer;
@property (nonatomic,strong) CAShapeLayer * bottomLineLayer;
@end


@implementation CWChangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        [self initLinesLayer];

    }
    return self;
}


- (void)initLinesLayer{
    // 上横线
    _topLineLayer = [CAShapeLayer layer];
    [_topLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _topLineLayer.fillColor = [UIColor clearColor].CGColor;
    _topLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _topLineLayer.lineWidth = LineHeight; // 必须设置layer的高度
    _topLineLayer.lineCap = kCALineCapRound;
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineHeight;
    [path moveToPoint:CGPointMake(CenterPositionX - LineWidth/2, TopY)];
    [path addLineToPoint:CGPointMake(CenterPositionX + LineWidth/2, TopY)];
    _topLineLayer.path = path.CGPath;
    [self.layer addSublayer:_topLineLayer];
    
    // 下横线
    _bottomLineLayer = [CAShapeLayer layer];
    [_bottomLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _bottomLineLayer.fillColor = [UIColor clearColor].CGColor;
    _bottomLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _bottomLineLayer.lineWidth = LineHeight;
    _bottomLineLayer.lineCap = kCALineCapRound;
    
    UIBezierPath * pathB = [UIBezierPath bezierPath];
    pathB.lineWidth = LineHeight;
    [pathB moveToPoint:CGPointMake(CenterPositionX - LineWidth/2, BottomY)];
    [pathB addLineToPoint:CGPointMake(CenterPositionX + LineWidth/2, BottomY)];
    _bottomLineLayer.path = pathB.CGPath;
    [self.layer addSublayer:_bottomLineLayer];
    
    // 中横线
    _changeLineLayer = [CAShapeLayer layer];
    [_changeLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _changeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLineLayer.lineWidth = LineHeight;
    _changeLineLayer.lineCap = kCALineCapRound;
    
    UIBezierPath * pathC = [UIBezierPath bezierPath];
    pathC.lineWidth = LineHeight;
    [pathC moveToPoint:CGPointMake(CenterPositionX - LineWidth/2, CenterPositionY)];
    [pathC addLineToPoint:CGPointMake(CenterPositionX + LineWidth/2, CenterPositionY)];
    _changeLineLayer.path = pathC.CGPath;
    [self.layer addSublayer:_changeLineLayer];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation1"]) {
        NSLog(@"动画1结束");
        [self animation2];
    }else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation2"]){
        [self animation3];
    }else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation3"]){
        [self animation4];
    }else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation4"]){
        _changeLineLayer.affineTransform = CGAffineTransformMakeTranslation(10, 0);
        
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.fromValue = @0;
        animation.toValue = @10;
        [_changeLineLayer addAnimation:animation forKey:nil];
    }
}



- (void)startAnimation{
    [_changeLineLayer removeAllAnimations];
    [_changeLineLayer removeFromSuperlayer];
    [_topLineLayer removeFromSuperlayer];
    [_bottomLineLayer removeFromSuperlayer];
    [self initLinesLayer];
    [self animation1];
//    [self animation4];
}

- (void)animation1{
    _changeLineLayer.strokeEnd = 0.4;
    CABasicAnimation * strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.toValue = @0.4;
    strokeAnimation.fromValue = @1.0;
    
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.fromValue = @0;
    positionAnimation.toValue = @-20;
    
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[strokeAnimation,positionAnimation];
    groupAnimation.duration = kAnimation1Duration;
    groupAnimation.removedOnCompletion = YES;
    
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnimation.delegate = self;
    [groupAnimation setValue:@"animation1" forKey:@"animationName"];
    [_changeLineLayer addAnimation:groupAnimation forKey:nil];
}

- (void)animation2{
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.fromValue = @-20;
    positionAnimation.toValue = @0;
    
    _changeLineLayer.strokeEnd = 0.8;
    CABasicAnimation * strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @0.4;
    strokeAnimation.toValue = @0.8;

    
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[positionAnimation,strokeAnimation];
    groupAnimation.duration = kAnimation2Duration;
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnimation.delegate = self;
    groupAnimation.removedOnCompletion = YES;
    [groupAnimation setValue:@"animation2" forKey:@"animationName"];
    [_changeLineLayer addAnimation:groupAnimation forKey:nil];
}

- (void)animation3{
    // 移除原来的changerLayer并重新创建
    [_changeLineLayer removeFromSuperlayer];
    
    _changeLineLayer = [CAShapeLayer layer];
    [_changeLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _changeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLineLayer.lineWidth = LineHeight;
    _changeLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_changeLineLayer];
// 反复测试 45度最好
    CGFloat angle = Radians(kAngle);
    
    CGFloat endPointX = CenterPositionX + Radius * cos(angle);
    CGFloat endPointY = CenterPositionY - Radius * sin(angle);
    
    CGFloat controlPX = endPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = CenterPositionY;

    CGFloat startPointX = CenterPositionX;
    CGFloat startPointY = CenterPositionY;
    
    // 三点画贝塞尔弧线
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineHeight;
    
    [path moveToPoint:CGPointMake(startPointX, startPointY)];
    [path addCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint1:CGPointMake(startPointX, startPointY) controlPoint2:CGPointMake(controlPX, controlPY)];
    
    UIBezierPath * path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CenterPositionX, CenterPositionY) radius:Radius startAngle:M_PI * 2-angle endAngle:M_PI+angle clockwise:NO];
    [path appendPath:path1];
    
    UIBezierPath * path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CenterPositionX, CenterPositionY) radius:Radius startAngle:M_PI+angle endAngle:M_PI+angle-M_PI*2 clockwise:NO]; // 最后一个参数为是否顺时针
    [path appendPath:path2];
    _changeLineLayer.path = path.CGPath;
    
    // 计算结束点的最终位置
//    CGFloat endPercent = M_PI*2*Radius/[self calculateTotalLength];
    // 计算开始点的最终位置 0-starPercent
    CGFloat starPercent = ([self calculateCurveLength] + Radians(180-kAngle*2-2)*Radius)/[self calculateTotalLength];
    
    _changeLineLayer.strokeStart = starPercent;
//    _changeLineLayer.strokeEnd = 1;
    
    CAKeyframeAnimation  * animation1 = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.values = @[@0,@1];
    
    CAKeyframeAnimation * animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    animation2.values = @[@0,@(starPercent)];
    
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1,animation2];
    groupAnimation.duration = kAnimation3Duration;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnimation.delegate = self;
    groupAnimation.removedOnCompletion = YES;
    [groupAnimation setValue:@"animation3" forKey:@"animationName"];
    [_changeLineLayer addAnimation:groupAnimation forKey:nil];

}

- (void)animation4{
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineWidth;
    
    CGFloat angle = Radians(kAngle);

    CGFloat startPointX = CenterPositionX + Radius * cos(angle);
    CGFloat startPointY = CenterPositionY - Radius * sin(angle);
    
    CGFloat controlPX = startPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = CenterPositionY;
    
    CGFloat endPointX = CenterPositionX +LineWidth/2;
    CGFloat endPointY = CenterPositionY;
    
   [path addArcWithCenter:CGPointMake(CenterPositionX, CenterPositionY) radius:Radius startAngle:M_PI+angle-M_PI*2 endAngle:M_PI+angle clockwise:YES];
//
    UIBezierPath * path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CenterPositionX, CenterPositionY) radius:Radius startAngle:M_PI+angle endAngle:M_PI * 2-angle clockwise:YES];
    [path appendPath:path1];

    UIBezierPath * path2 = [UIBezierPath bezierPath];
    [path addCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint1:CGPointMake(startPointX, startPointY) controlPoint2:CGPointMake(controlPX, controlPY)];
    [path appendPath:path2];
    
    UIBezierPath * path3 = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(endPointX, endPointY)];
    [path addLineToPoint:CGPointMake(endPointX - LineWidth -10, endPointY)];
    [path appendPath:path3];
    _changeLineLayer.path = path.CGPath;
    
    CGFloat startPercent = (LineWidth)/([self calculateTotalAnimation4PathLength]+(LineWidth));
    CGFloat endPercent = 2* M_PI *Radius / ([self calculateTotalAnimation4PathLength] + (LineWidth));
    _changeLineLayer.strokeStart = 1-startPercent;
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    animation.values = @[@0,@0.3,@(1-startPercent)];
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.values = @[@(endPercent),@(endPercent),@1];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation,animation1];
    groupAnimation.duration = kAnimation4Duration;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.delegate = self;
    [groupAnimation setValue:@"animation4" forKey:@"animationName"];
    [_changeLineLayer addAnimation:groupAnimation forKey:nil];
    
}



#pragma mark - 求贝塞尔曲线的长度
-(CGFloat) bezierCurveLengthFromStartPoint:(CGPoint)start toEndPoint:(CGPoint) end withControlPoint:(CGPoint) control
{
    const int kSubdivisions = 50;
    const float step = 1.0f/(float)kSubdivisions;
    
    float totalLength = 0.0f;
    CGPoint prevPoint = start;
    
    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (int i = 1; i <= kSubdivisions; i++)
    {
        float t = i*step;
        
        float x = (1.0 - t)*(1.0 - t)*start.x + 2.0*(1.0 - t)*t*control.x + t*t*end.x;
        float y = (1.0 - t)*(1.0 - t)*start.y + 2.0*(1.0 - t)*t*control.y + t*t*end.y;
        
        CGPoint diff = CGPointMake(x - prevPoint.x, y - prevPoint.y);
        
        totalLength += sqrtf(diff.x*diff.x + diff.y*diff.y); // Pythagorean
        
        prevPoint = CGPointMake(x, y);
    }
    
    return totalLength;
}
// 获取3点曲线段的长度
- (CGFloat)calculateCurveLength{
    
    CGFloat angle = Radians(kAngle);
    
    CGFloat endPointX = CenterPositionX + Radius * cos(angle);
    CGFloat endPointY = CenterPositionY - Radius * sin(angle);
    
    CGFloat controlPX = endPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = CenterPositionY;
    
    CGFloat startPointX = CenterPositionX ;
    CGFloat startPointY = CenterPositionY;
    
    CGFloat length = [self bezierCurveLengthFromStartPoint:CGPointMake(startPointX, startPointY) toEndPoint:CGPointMake(endPointX, endPointY) withControlPoint:CGPointMake(controlPX, controlPY)];
    
    return length;
}
// 获取整个曲线的长度
- (CGFloat)calculateTotalLength{
    
    CGFloat pathLength = [self calculateCurveLength];
    // 一个圆＋120度弧线的长度
    CGFloat totalLength = pathLength + (Radians(180-kAngle*2)+ M_PI*2)*Radius;
    
    
    return totalLength;
}

- (CGFloat)calculateTotalAnimation4PathLength{
    
    CGFloat angle = Radians(kAngle);
    
    CGFloat startPointX = CenterPositionX + Radius * cos(angle);
    CGFloat startPointY = CenterPositionY - Radius * sin(angle);
    
    CGFloat controlPX = startPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = CenterPositionY;
    
    CGFloat endPointX = CenterPositionX +LineWidth/2;
    CGFloat endPointY = CenterPositionY;
    
    CGFloat pathLength = [self bezierCurveLengthFromStartPoint:CGPointMake(startPointX, startPointY) toEndPoint:CGPointMake(endPointX, endPointY) withControlPoint:CGPointMake(controlPX, controlPY)];
    
    CGFloat totalLength = pathLength + (Radians(180-kAngle*2)+ M_PI*2)*Radius;
    
    return totalLength;
}

@end
