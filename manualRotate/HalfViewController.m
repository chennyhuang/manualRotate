//
//  HalfViewController.m
//  manualRotate
//
//  Created by hzy on 2018/7/29.
//  Copyright © 2018年 hzy. All rights reserved.
//

#import "HalfViewController.h"
#import "Common.h"
@interface HalfViewController ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,assign) CGRect originRect;//记录初始rect
@end

@implementation HalfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originRect = CGRectMake(0, 80, kAPPWidth, 200);
}

- (IBAction)click:(id)sender {
    self.redView.frame = self.originRect;
    self.label.frame = CGRectMake(0, 0, 300, 50);
    [self.redView addSubview:self.label];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.redView];
    [self onDeviceOrientationChangeWithObserver];
}

- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//旋转
- (void)onDeviceOrientationChange{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        //添加到keyWindow，转换redView视图层级
        [[UIApplication sharedApplication].keyWindow addSubview:self.redView];
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.redView.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(-M_PI/2):CGAffineTransformMakeRotation(M_PI/2);
            self.redView.frame = CGRectMake(0, 0, kAPPWidth, KAppHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (orientation==UIDeviceOrientationPortrait){
        //添加到原来的视图上
        [self.view addSubview:self.redView];
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.redView.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.redView.frame = self.originRect;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.userInteractionEnabled = YES;
        _label.text = @"点我退出,我是视频播放器";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:20.0f];
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}

- (UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_redView addGestureRecognizer:tap];
    }
    return _redView;
}

- (void)tap{
    [self.redView removeFromSuperview];
    self.redView = nil;
}
@end
