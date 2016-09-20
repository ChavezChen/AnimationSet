//
//  DrawView.h
//  画板
//
//  Created by chavez on 16/9/9.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// 清屏
- (void)clear;
// 撤销
- (void)undo;
// 橡皮擦
- (void)erase;
// 设置线的宽度
- (void)setLineWidth:(CGFloat)lineWidth;
// 设置线的颜色
- (void)setLineColor:(UIColor *)color;

@property (nonatomic,strong)UIImage *image;


@end
