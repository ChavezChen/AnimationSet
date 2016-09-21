//
//  CWChangeView.m
//  CWAnimation
//
//  Created by macmini on 16/5/19.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWChangeView.h"




static CGFloat const kAnimation1Duration = 0.25;
static CGFloat const kAnimation2Duration = 0.25;
static CGFloat const kAnimation3Duration = 3.0;
static CGFloat const kAnimation4Duration = 3.0;



static CGFloat const LineWidth = 100.0f;
static CGFloat const Radius = 100.0f;
static CGFloat const LineHeight = 8.0f;
static CGFloat const LineGapHeight = 20.0f;
static CGFloat const kAngle = 45;    // 三点曲线的角度大小

static CGFloat const transX = 20;  // 动画在x轴上面的偏移


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

    _topLineLayer.frame = CGRectMake(CenterPositionX - LineWidth/2, TopY, LineWidth, LineHeight);
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineHeight;
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(LineWidth, 0)];
    _topLineLayer.path = path.CGPath;
    _topLineLayer.anchorPoint = CGPointMake(1, 0);
    _topLineLayer.position = CGPointMake(self.layer.bounds.size.width/2 + LineWidth/2, TopY);
    [self.layer addSublayer:_topLineLayer];
    
    // 下横线
    _bottomLineLayer = [CAShapeLayer layer];
    [_bottomLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _bottomLineLayer.fillColor = [UIColor clearColor].CGColor;
    _bottomLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _bottomLineLayer.lineWidth = LineHeight;
    _bottomLineLayer.lineCap = kCALineCapRound;
    _bottomLineLayer.frame = CGRectMake(CenterPositionX - LineWidth/2, BottomY, LineWidth, LineHeight);
    UIBezierPath * pathB = [UIBezierPath bezierPath];
    pathB.lineWidth = LineHeight;

    [pathB moveToPoint:CGPointZero];
    [pathB addLineToPoint:CGPointMake(LineWidth, 0)];
    _bottomLineLayer.anchorPoint = CGPointMake(1, 0);
    _bottomLineLayer.position = CGPointMake(self.layer.bounds.size.width/2 + LineWidth/2, BottomY);
    _bottomLineLayer.path = pathB.CGPath;
    [self.layer addSublayer:_bottomLineLayer];
    
    // 中横线
    _changeLineLayer = [CAShapeLayer layer];
    [_changeLineLayer setStrokeColor:[UIColor whiteColor].CGColor];
    _changeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLineLayer.lineWidth = LineHeight;
    _changeLineLayer.lineCap = kCALineCapRound;
    
    _changeLineLayer.frame = CGRectMake(CenterPositionX - LineWidth/2, CenterPositionY, LineWidth, LineHeight);
    
    UIBezierPath * pathC = [UIBezierPath bezierPath];
    pathC.lineWidth = LineHeight;
    [pathC moveToPoint:CGPointZero];
    [pathC addLineToPoint:CGPointMake(LineWidth, 0)];
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
//        animation.fromValue = @0;
        animation.byValue = @10;
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
//    [self animation3];
}

- (void)animation1{
    _changeLineLayer.strokeEnd = 0.4;
    CABasicAnimation * strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.toValue = @0.4;
    strokeAnimation.fromValue = @1.0;
    
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    positionAnimation.fromValue = @0;
    positionAnimation.byValue = @(-transX);
    
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
//    positionAnimation.fromValue = @-20;
    positionAnimation.byValue = @(transX);
    
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
    _changeLineLayer.frame = CGRectMake(CenterPositionX - LineWidth/2+transX, CenterPositionY+LineHeight*0.5, LineWidth, LineHeight);

    [self.layer addSublayer:_changeLineLayer];
// 反复测试 45度最好
    CGFloat angle = Radians(kAngle);
    
    CGFloat endPointX =  Radius * cos(angle);
    CGFloat endPointY = - Radius * sin(angle);
    
    CGFloat controlPX = endPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = 0;

    CGFloat startPointX = 0;
    CGFloat startPointY = 0;
    
    // 三点画贝塞尔弧线
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineHeight;
    
    [path moveToPoint:CGPointMake(startPointX, startPointY)];
    [path addCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint1:CGPointMake(startPointX, startPointY) controlPoint2:CGPointMake(controlPX, controlPY)];
    
    UIBezierPath * path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:Radius startAngle:M_PI * 2-angle endAngle:M_PI+angle clockwise:NO];
    [path appendPath:path1];
    
    UIBezierPath * path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:Radius startAngle:M_PI+angle endAngle:M_PI+angle-M_PI*2 clockwise:NO]; // 最后一个参数为是否顺时针
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
    
    //平移量
    CGFloat toValue = LineWidth *(1- cos(M_PI_4)) /2.0 ;
    //finished 最终状态
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI_4);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(toValue-(LineWidth * 0.5 + transX * 0.5), -transX * 0.5);
    CGAffineTransform transform3 = CGAffineTransformMakeRotation(M_PI_4);
    CGAffineTransform transform4 = CGAffineTransformMakeTranslation(toValue-(LineWidth * 0.5 + transX * 0.5), transX * 0.5);

    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    _topLineLayer.affineTransform = transform;
    transform = CGAffineTransformConcat(transform3, transform4);
    _bottomLineLayer.affineTransform = transform;


    //平移x
    CABasicAnimation *translationAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimationX.fromValue = [NSNumber numberWithFloat:0];
//    translationAnimation.toValue = [NSNumber numberWithFloat:-toValue];
    translationAnimationX.byValue = @(-45);
    
    
    //角度关键帧 上横线的关键帧 0 - 10° - (-55°) - (-45°)
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:Radians(10) ],
                                  [NSNumber numberWithFloat:Radians(-10) - M_PI_4 ],
                                  [NSNumber numberWithFloat:- M_PI_4 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimationX, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = kAnimation3Duration;
    transformGroup1.removedOnCompletion = YES;
    [_topLineLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧 0 - （-10°） - (55°) - (45°)
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:Radians(-10) ],
                                  [NSNumber numberWithFloat:Radians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat: M_PI_4 ]
                                  ];

    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimationX, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = kAnimation3Duration ;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLineLayer addAnimation:transformGroup2 forKey:nil];
}

- (void)animation4{
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = LineWidth;
    
    CGFloat angle = Radians(kAngle);

    CGFloat startPointX = Radius * cos(angle);
    CGFloat startPointY = - Radius * sin(angle);
    
    CGFloat controlPX = startPointX + Radius * tan(angle) * cos(angle);
    CGFloat controlPY = 0;
    
    CGFloat endPointX = LineWidth/2;
    CGFloat endPointY = 0;
    
   [path addArcWithCenter:CGPointMake(0, 0) radius:Radius startAngle:M_PI+angle-M_PI*2 endAngle:M_PI+angle clockwise:YES];
//
    UIBezierPath * path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:Radius startAngle:M_PI+angle endAngle:M_PI * 2-angle clockwise:YES];
    [path appendPath:path1];

    UIBezierPath * path2 = [UIBezierPath bezierPath];
    [path addCurveToPoint:CGPointMake(endPointX, endPointY-4) controlPoint1:CGPointMake(startPointX, startPointY) controlPoint2:CGPointMake(controlPX, controlPY)];
    [path appendPath:path2];
    
    UIBezierPath * path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(LineWidth-30, endPointY-4)];
    [path3 addLineToPoint:CGPointMake(-30, endPointY-4)];
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
    
    // 还原
    _topLineLayer.affineTransform = CGAffineTransformIdentity;
    _bottomLineLayer.affineTransform = CGAffineTransformIdentity;
    
    
    
    //平移x
    CABasicAnimation *translationAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimationX.fromValue = [NSNumber numberWithFloat:-45];
    //    translationAnimation.toValue = [NSNumber numberWithFloat:-toValue];
    translationAnimationX.toValue = @(0);
    
    
    //角度关键帧 上横线的关键帧 0 - 10° - (-55°) - (-45°)
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:- M_PI_4],
                                  [NSNumber numberWithFloat:Radians(-10) - M_PI_4],
                                  [NSNumber numberWithFloat:Radians(10)],
                                  [NSNumber numberWithFloat:0 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimationX, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = kAnimation3Duration;
    transformGroup1.removedOnCompletion = YES;
    [_topLineLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧 0 - （-10°） - (55°) - (45°)
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat:M_PI_4],
                                  [NSNumber numberWithFloat:Radians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat:Radians(-10) ],
                                  [NSNumber numberWithFloat:0]
                                  ];
    
    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimationX, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = kAnimation3Duration ;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLineLayer addAnimation:transformGroup2 forKey:nil];
    
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
