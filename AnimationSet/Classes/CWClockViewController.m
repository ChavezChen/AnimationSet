//
//  CWClockViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/7.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWClockViewController.h"
#import "CWClockView.h"

@interface CWClockViewController ()<ClockDelegate>
@property (weak, nonatomic) IBOutlet CWClockView *clockView;

@end

@implementation CWClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clockView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ClockDelegate

- (void)clockView:(CWClockView *)view passworld:(NSString *)pasW{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"输入的密码" message:pasW preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
