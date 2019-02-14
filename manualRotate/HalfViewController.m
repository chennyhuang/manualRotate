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

/// Container view of a small screen state player.
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic,assign) CGRect originRect;//记录初始rect

@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;
/// Container view of a full screen state player.
@property (nonatomic, strong) UIView *fullScreenContainerView;

@property (nonatomic,strong) UIButton *fullBtn;

@property (nonatomic,assign) BOOL isFullScreen;
@end

@implementation HalfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originRect = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, kAPPWidth, 200);
}

- (IBAction)click:(id)sender {
    self.containerView.frame = self.originRect;
    
    self.redView.frame = self.containerView.bounds;
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.redView];
    
    [self.redView addSubview:self.label];
    [self.redView addSubview:self.fullBtn];
    
    [self onDeviceOrientationChangeWithObserver];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
    [self updateFrames];
}



#pragma mark private
- (UIView *)fullScreenContainerView {
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}

- (void)updateFrames{
    self.label.frame = CGRectMake(0, 0, 200, 50);
    self.fullBtn.frame = CGRectMake(self.redView.bounds.size.width - 44 - 20, self.redView.bounds.size.height - 44, 44, 44);
}

- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//旋转
- (void)onDeviceOrientationChange{
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (_currentOrientation == currentOrientation) {
        return;
    }
    switch (_currentOrientation) {
        case UIInterfaceOrientationPortrait: {
            [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait];
        }
        break;
        case UIInterfaceOrientationLandscapeLeft: {
            [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeLeft];
        }
        break;
        case UIInterfaceOrientationLandscapeRight: {
            [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight];
        }
        break;
        default: break;
    }
}

/// Gets the rotation Angle of the transformation.
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation{
    UIView *superview = nil;
    CGRect frame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        superview = self.fullScreenContainerView;
        self.redView.frame = [self.redView convertRect:self.redView.frame toView:superview];
        /// 先加到window上，效果更好一些
        [superview addSubview:self.redView];
        self.isFullScreen = YES;
    } else {
        superview = self.containerView;
        self.isFullScreen = NO;
    }
    frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [UIApplication sharedApplication].statusBarOrientation = orientation;
#pragma clang diagnostic pop
    
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.transform = [self getTransformRotationAngle:orientation];
        self.redView.frame = frame;
        //调用viewWillLayoutSubviews 更新UI
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        NSLog(@"redView.frame ---- %@",NSStringFromCGRect(self.redView.frame));
        NSLog(@"redView.bounds ---- %@",NSStringFromCGRect(self.redView.bounds));

    } completion:^(BOOL finished) {
        [superview addSubview:self.redView];
        self.redView.frame = superview.bounds;
        [self updateFrames];
    }];
}

#pragma mark getter setter
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.userInteractionEnabled = YES;
        _label.text = @"我是视频播放器";
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
    }
    return _redView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

- (UIButton *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [[UIButton alloc] init];
        [_fullBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [_fullBtn addTarget:self action:@selector(full:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}

- (void)full:(UIButton *)btn{
    self.isFullScreen = !self.isFullScreen;
    if (self.isFullScreen) {//全屏
        [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight];
    } else {
        [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait];
    }
}

@end
