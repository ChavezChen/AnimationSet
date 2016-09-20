//
//  HandleView.h
//  画板
//
//  Created by chavez on 16/9/9.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandleView;
@protocol handleViewDelegate <NSObject>

- (void)handleImageVIew:(HandleView *)view image:(UIImage *)image;

@end

@interface HandleView : UIView

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,weak) id <handleViewDelegate>delegate;

@end
