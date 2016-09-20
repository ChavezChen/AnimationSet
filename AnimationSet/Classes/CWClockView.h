//
//  CWClockView.h
//  AnimationSet
//
//  Created by chavez on 16/9/7.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWClockView;

@protocol ClockDelegate <NSObject>

- (void)clockView:(CWClockView *)view passworld:(NSString *)pasW;

@end


@interface CWClockView : UIView

@property (nonatomic,weak) id <ClockDelegate>delegate;


@end
