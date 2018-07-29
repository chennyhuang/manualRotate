//
//  FullViewController.m
//  manualRotate
//
//  Created by hzy on 2018/7/29.
//  Copyright © 2018年 hzy. All rights reserved.
//

#import "FullViewController.h"
#import "Common.h"
@interface FullViewController ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIView *redView;
@end

@implementation FullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)click:(id)sender {
    self.redView.frame = CGRectMake(0, 0, kAPPWidth, KAppHeight);
    self.label.frame = CGRectMake(0, 0, 200, 100);
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
        
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.redView.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(-M_PI/2):CGAffineTransformMakeRotation(M_PI/2);
            self.redView.bounds = CGRectMake(0, 0, KAppHeight, kAPPWidth);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (orientation==UIDeviceOrientationPortrait){
        
        [UIView animateWithDuration:kRotateAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.redView.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.redView.bounds = CGRectMake(0, 0, kAPPWidth, KAppHeight);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.userInteractionEnabled = YES;
        _label.text = @"点我退出";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:30.0f];
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
