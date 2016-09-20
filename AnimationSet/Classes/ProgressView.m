//
//  ProgressView.m
//  下载进度条
//
//  Created by km_cloud_001 on 16/7/19.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView


- (void)drawRect:(CGRect)rect {
    
    //画弧
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    CGPoint center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width * 0.5 - 10;
    CGFloat startAngle = -M_PI_2;
    CGFloat angle = self.progressValue * M_PI * 2;
    CGFloat endAngle = startAngle + angle;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor blueColor] set];
    
    CGContextSetLineWidth(ctx, 15);

    //3.把路径添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    //4.把上下文的内容渲染到View的layer上
    CGContextStrokePath(ctx);

    
    
    
    
}

- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    // 注意：如果是手动调用改方法，不会给你创建跟view相关联的上下文
    // 只有系统调用该方法时，才会创建跟view相关联的上下文
//    [self drawRect:self.bounds];
    [self setNeedsDisplay];
}


@end
