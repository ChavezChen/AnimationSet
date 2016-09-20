//
//  ViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/20.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "ViewController.h"
#import "CWClockViewController.h"
#import "CWClipViewController.h"
#import "CWDrawViewController.h"
#import "CWQQViewController.h"
#import "CWFoldViewController.h"
#import "CWRotateViewController.h"
#import "CWDownProgressViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end



@implementation ViewController


static NSString * const ID = @"cell";

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initDataSource];
}

- (void)initDataSource{
    NSArray * array = @[@"手势解锁",@"图形裁剪",@"画板(照片可缩小移动，长按照片可以涂鸦)",@"QQ气泡拉扯",@"图片折叠",@"趣味动画(点击屏幕开始动画)",@"圆形下载进度条"];
    [self.dataSource addObjectsFromArray:array];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:{
            CWClockViewController * vc0 = [[CWClockViewController alloc] init];
            vc = vc0;
        }
            break;
        case 1:{
            CWClipViewController * vc1 = [[CWClipViewController alloc] init];
            vc = vc1;
        }
            break;
        case 2:{
            CWDrawViewController *vc2 = [[CWDrawViewController alloc] init];
            vc = vc2;
        }
            break;
        case 3:{
            CWQQViewController * vc3 = [[CWQQViewController alloc] init];
            vc = vc3;
        }
            break;
        case 4:{
            CWFoldViewController * vc4 = [[CWFoldViewController alloc] init];
            vc = vc4;
        }
            break;
        case 5:{
            CWRotateViewController * vc5 = [[CWRotateViewController alloc] init];
            vc = vc5;
        }
            break;
        case 6:{
            CWDownProgressViewController * vc6 = [[CWDownProgressViewController alloc] init];
            vc = vc6;
        }
            break;
        default:
            break;
    }
    
    [self push2ViewController:vc title:self.dataSource[indexPath.row]];
}

- (void)push2ViewController:(UIViewController *)vc title:(NSString *)title{
    vc.navigationItem.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
