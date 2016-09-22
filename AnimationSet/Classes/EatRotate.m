//
//  EatRotate.m
//  旋转吃呀吃
//
//  Created by chavez on 16/9/22.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "EatRotate.h"


static CGFloat const kRaduis = 50;
static CGFloat const angel = 20;
static CGFloat const kLineWidth = 3;


#define kFlag 1   // 动画方案

#define KAngle(x) (M_PI / 180) * (x)
#define kCenterY self.bounds.size.height * 0.5
#define kCenterX self.bounds.size.width * 0.5

@interface EatRotate ()
@property (nonatomic,weak) CAShapeLayer *arcLayer;
@property (nonatomic,weak) CAShapeLayer *arrowL;
@property (nonatomic,weak) CAShapeLayer *arrowR;
@property (nonatomic,weak) CAReplicatorLayer *repL;

@end


@implementation EatRotate

static int i = 0;
+(Class)layerClass{
    return [CAReplicatorLayer class];
}

- (void)awakeFromNib{
    [self setupUI];
}


- (void)setupUI{
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    repL.frame = self.bounds;
    repL.instanceCount = 2;
    repL.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    repL.instanceDelay = 0.5;
    [self.layer addSublayer:repL];
    self.repL = repL;
    
    // 画圆弧
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.frame = CGRectMake(kCenterX - 100, kCenterY - 100, 200, 100); // 居中
//    arcLayer.backgroundColor = [UIColor redColor].CGColor;
    
    
    CGPoint arcCenter = CGPointMake(CGRectGetWidth(arcLayer.bounds) * 0.5, CGRectGetHeight(arcLayer.bounds));
    CGFloat starAngel = -KAngle(angel);
    CGFloat endAngle = -KAngle(180-angel-5);
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:kRaduis startAngle:starAngel endAngle:endAngle clockwise:NO];
    
    arcLayer.path = path.CGPath;
    [arcLayer setLineWidth:kLineWidth];
    [arcLayer setStrokeColor:[UIColor whiteColor].CGColor];
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.lineCap = kCALineCapRound;
    
    [repL addSublayer:arcLayer];
    self.arcLayer = arcLayer;
    
    // 画箭头
    // 算上圆弧左边顶点的位置
    CGFloat x = kCenterX - kRaduis*sin(angel);
    CGFloat y = kCenterY - kRaduis*cos(angel);
    
    CGFloat wh = 15;
    // 左边箭头
    CAShapeLayer * arrowL = [CAShapeLayer layer];
    arrowL.frame = CGRectMake(x-wh, y-wh, wh, wh);
    arrowL.anchorPoint = CGPointMake(1, 1);
    //anchorPoint改变了位置，重新设置一下位置
    arrowL.frame = CGRectMake(x-wh, y-wh, wh, wh);
    [arrowL setLineWidth:kLineWidth];
    [arrowL setStrokeColor:[UIColor whiteColor].CGColor];
    arrowL.fillColor = [UIColor clearColor].CGColor;
    arrowL.lineCap = kCALineCapRound;
    
    UIBezierPath * pathL = [UIBezierPath bezierPath];
    [pathL moveToPoint:CGPointMake(wh/3*2, 0)];
    [pathL addLineToPoint:CGPointMake(wh, wh)];
    arrowL.path = pathL.CGPath;
    
    [repL addSublayer:arrowL];
    self.arrowL = arrowL;
    
    // 右边箭头
    CAShapeLayer *arrowR = [CAShapeLayer layer];
    arrowR.frame = CGRectMake(x, y-wh, wh, wh);
    arrowR.anchorPoint = CGPointMake(0, 1);
    arrowR.frame = CGRectMake(x, y-wh, wh, wh);
    [arrowR setLineWidth:kLineWidth];
    [arrowR setStrokeColor:[UIColor whiteColor].CGColor];
    arrowR.fillColor = [UIColor clearColor].CGColor;
    arrowR.lineCap = kCALineCapRound;
    
    UIBezierPath *pathR = [UIBezierPath bezierPath];
    [pathR moveToPoint:CGPointMake(wh, wh/3*2)];
    [pathR addLineToPoint:CGPointMake(0, wh)];
    arrowR.path = pathR.CGPath;
    [repL addSublayer:arrowR];
    self.arrowR = arrowR;
    
    // 添加动画
    if (!kFlag) {
        [self animation1];
    }else{
        [self animation];
    }
    
    
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    anim.duration = 3;
//    anim.repeatCount = MAXFLOAT;
//    anim.values = @[@(-M_PI/5),@(-M_PI*2)];
//    anim.keyTimes = @[@0.2,@1];
//    [repL addAnimation:anim forKey:nil];
    
}

#pragma mark - 动画方案1
- (void)animation1{
    CABasicAnimation *rotateAnim = [CABasicAnimation animation];
    rotateAnim.keyPath = @"transform.rotation.z";
    rotateAnim.duration = 3;
    rotateAnim.repeatCount = 1;
    if (i != 0) {
        rotateAnim.fromValue = @(-M_PI * 2);
    }

    rotateAnim.byValue = @(-M_PI*2+M_PI/6);
    rotateAnim.delegate = self;
    rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [rotateAnim setValue:@"animation1" forKey:@"animationName"];
    
    [self.repL addAnimation:rotateAnim forKey:nil];
    

    CAKeyframeAnimation *animL = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animL.duration = 0.25;
    animL.repeatCount = 2;
    animL.autoreverses = YES;
    animL.values = @[@0,@0,@(-M_PI/1.5)];
//    animL.keyTimes = @[@0,@0.25,@0.5];
    [self.arrowL addAnimation:animL forKey:nil];
    
    
    CAKeyframeAnimation *animR = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animR.duration = 0.25;
    animR.repeatCount = 2;
    animR.autoreverses = YES;
    animR.values = @[@0,@0,@(M_PI/1.5)];
//    animR.keyTimes = @[@0,@0.25,@0.5];
    [self.arrowR addAnimation:animR forKey:nil];
}

- (void)animation2{
    CABasicAnimation *rotateAnim = [CABasicAnimation animation];
    rotateAnim.keyPath = @"transform.rotation.z";
    rotateAnim.duration = 2;
    rotateAnim.repeatCount = 1;
    rotateAnim.fromValue = @(-M_PI*2+M_PI/6);
    rotateAnim.byValue = @(-M_PI/6);
    rotateAnim.delegate = self;
    [rotateAnim setValue:@"animation2" forKey:@"animationName"];
    
    [self.repL addAnimation:rotateAnim forKey:nil];
    
    
}


#pragma mark -动画方案2(合理方案)
- (void)animation{
    CABasicAnimation *rotateAnim = [CABasicAnimation animation];
    rotateAnim.keyPath = @"transform.rotation.z";
    rotateAnim.duration = 3;
    rotateAnim.repeatCount = MAXFLOAT;
    rotateAnim.byValue = @(-M_PI*2);
    rotateAnim.delegate = self;
    rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [rotateAnim setValue:@"animation1" forKey:@"animationName"];
    [self.repL addAnimation:rotateAnim forKey:nil];
    
    CAKeyframeAnimation *animL = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animL.duration = 3;
    animL.repeatCount = MAXFLOAT;
    animL.values = @[@0,@(-M_PI/1.5),@0,@(-M_PI/1.5),@0];
        animL.keyTimes = @[@0.05,@0.1,@0.15,@0.2,@0.25];
    [self.arrowL addAnimation:animL forKey:nil];
    
    CAKeyframeAnimation *animR = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animR.duration = 3;
    animR.repeatCount = MAXFLOAT;
    animR.values = @[@0,@(M_PI/1.5),@0,@(M_PI/1.5),@0];
    animR.keyTimes = @[@0.05,@0.1,@0.15,@0.2,@0.25];
    [self.arrowR addAnimation:animR forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (!kFlag) {
        if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation1"]) {
            NSLog(@"动画1结束");
            i = 1;
            [self animation2];
        }else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animation2"]){
            [self animation1];
        }
    }else{
        
    }
    
}


@end
