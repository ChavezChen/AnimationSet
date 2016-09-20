//
//  CWDrawViewController.m
//  AnimationSet
//
//  Created by chavez on 16/9/20.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWDrawViewController.h"
#import "DrawView.h"
#import "HandleView.h"

@interface CWDrawViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,handleViewDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@end

@implementation CWDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 禁用左划返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启左划返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
// 清屏
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}

// 撤销
- (IBAction)undo:(id)sender {
    [self.drawView undo];
}

// 橡皮擦
- (IBAction)erase:(id)sender {
    [self.drawView erase];
}

// 设置线的宽度
- (IBAction)setLineWidth:(UISlider *)sender {
    [self.drawView setLineWidth:sender.value];
}

// 设置线的颜色
- (IBAction)setLineColor:(UIButton *)sender {
    [self.drawView setLineColor:sender.backgroundColor];
}


// 照片  照片可放大缩小，长按照片可进行涂鸦
- (IBAction)photo:(id)sender {
    // 从下同相册当中选择一张图片
    //1.弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    //  设置照片的来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // modal出系统相册
    [self presentViewController:pickerVC animated:YES completion:nil];
}

// 当选择某一个照片时，会调用这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
//    NSLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 将照片写到桌面
    //    NSData *data = UIImageJPEGRepresentation(image, 1);
    //    [data writeToFile:@"/Users/chavez/Desktop/photo.jpg" atomically:YES];
    
    
    HandleView * handleView= [[HandleView alloc] init];
    handleView.frame = self.drawView.frame;
    handleView.backgroundColor = [UIColor clearColor];
    handleView.image = image;
    handleView.delegate = self;
    [self.view addSubview:handleView];
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //    self.drawView.image = image;
    
}


#pragma mark -handleViewDelegate
- (void)handleImageVIew:(HandleView *)view image:(UIImage *)image{
    self.drawView.image = image;
    [view removeFromSuperview];
}


// 保存
- (IBAction)save:(id)sender {
    // 把绘制的东西保存到相册当中
    
    //1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    
    //2.把画板的内容渲染到上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    
    //3.从上下文当中取出一张图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.关闭上下文
    UIGraphicsEndImageContext();
    
    //5.把图片保存到系统相册当中  保存完毕的时候 调用哪个对象的哪个方法
    //  注意：@selector里面的方法不能瞎写，必须得是image:didFinishSavingWithError:contextInfo:
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 保存完毕时调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存到相册成功" preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addAction:action];
    
    [self presentViewController:alerVC animated:YES completion:nil];
    
    NSLog(@"save success");
    
}
@end
