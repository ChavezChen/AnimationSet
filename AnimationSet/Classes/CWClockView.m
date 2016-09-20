//
//  CWClockView.m
//  AnimationSet
//
//  Created by chavez on 16/9/7.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWClockView.h"

@interface CWClockView ()
@property (nonatomic,strong)NSMutableArray *selectedbuttons;
// 当前手指所在的点
@property (nonatomic,assign)CGPoint curP;
@end


@implementation CWClockView

- (NSMutableArray *)selectedbuttons{
    if (_selectedbuttons == nil) {
        _selectedbuttons = [NSMutableArray array];
    }
    return _selectedbuttons;
}

- (void)awakeFromNib{
    
    // 搭建界面 添加按钮
    [self setup];
    
}


// 搭建界面 添加按钮
- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < 9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 点击手势不被按钮拦截
        button.userInteractionEnabled = NO;
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        button.tag = i;
        [self addSubview:button];
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return self;
//}


// 获取当前手指所在的点
- (CGPoint)getCurrentPoint:(NSSet *)touches{
    UITouch * touch = [touches anyObject];
    return [touch locationInView:self];
}

// 给定一个点，判断给定的点在不在按钮身上
- (UIButton *)btnRectContainsPoint:(CGPoint)point{
    for (UIButton * btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            //  让当前按钮成为选中状态
            //            btn.selected = YES;
            return btn;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 1.当前的手指所在的点在不在按钮上，如果在，让按钮称为选中状态
    CGPoint curP = [self getCurrentPoint:touches];
    // 2.判断点curP在不在按钮身上
    UIButton * btn = [self btnRectContainsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedbuttons addObject:btn];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 1.当前的手指所在的点在不在按钮上，如果在，让按钮称为选中状态
    //    UITouch * touch = [touches anyObject];
    //    CGPoint curP = [touch locationInView:self];
    CGPoint curP = [self getCurrentPoint:touches];
    self.curP = curP;
    // 2.判断点curP在不在按钮身上
    UIButton * btn = [self btnRectContainsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedbuttons addObject:btn];
        
    }
    //  重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableString * str = [NSMutableString string];
    // 1.取消所有选中的按钮
    for (UIButton * btn in self.selectedbuttons) {
        [str appendFormat:@"%li",btn.tag];
        btn.selected = NO;
    }
    // 2.清空路径
    [self.selectedbuttons removeAllObjects];
    [self setNeedsDisplay];
    // 3.查看当前选中按钮的顺序
//    NSLog(@"%@",str);
    
    if (_delegate && [_delegate respondsToSelector:@selector(clockView:passworld:)]) {
        [_delegate clockView:self passworld:str];
    }
}

- (void)drawRect:(CGRect)rect{
    if (!self.selectedbuttons.count) {
        return;
    }
    // 1.创建路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    // 2.取出所有保存的选中的按钮
    for (int i = 0; i < self.selectedbuttons.count; i++) {
        // 取出每一个按钮
        UIButton * btn = self.selectedbuttons[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    
    // 添加一根线到当前手指所在的点
    [path addLineToPoint:self.curP];
    
    
    //  设置路径的状态
    path.lineWidth = 8;
    [[UIColor cyanColor] set];
    [path setLineJoinStyle:kCGLineJoinRound];
    // 3.绘制路径
    [path stroke];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    
    int column = 3;
    CGFloat margin = (self.bounds.size.width - (btnWH * column)) / (column +1);
    int curC = 0;
    int curR = 0;
    // 取出每一个按钮，设置按钮的frame
    for (int i = 0; i < self.subviews.count; i++) {
        
        curC = i % column;
        curR = i / column;
        
        x = margin + (btnWH + margin) * curC;
        y = margin + (btnWH + margin) * curR;
        
        UIButton * btn = self.subviews[i];
        // 设置按钮的frame
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}



@end
