//
//  CWRotateViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/20.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWRotateViewController.h"
#import "CWChangeView.h"

@interface CWRotateViewController ()
@property (nonatomic,strong)CWChangeView * myView;
@end

@implementation CWRotateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    self.myView = [[CWChangeView alloc] initWithFrame:frame];
    
    
    [self.view addSubview:_myView];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_myView startAnimation];
}

@end
