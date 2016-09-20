//
//  CWDownProgressViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/20.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWDownProgressViewController.h"
#import "ProgressView.h"
@interface CWDownProgressViewController ()
@property (strong, nonatomic) IBOutlet UILabel *valueTitle;
@property (strong, nonatomic) IBOutlet ProgressView *progressView;
@end

@implementation CWDownProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChange:(UISlider *)sender {
    
    CGFloat value = sender.value;
    self.valueTitle.text = [NSString stringWithFormat:@"%.2f%%",value * 100];
    self.progressView.progressValue = value;
}

@end
