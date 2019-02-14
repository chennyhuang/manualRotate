//
//  HZNavigatonController.m
//  diibeeapp_ios
//
//  Created by huangzhenyu on 2018/3/14.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//

#import "HZNavigatonController.h"
//#import "CommonDefines.h"

@interface HZNavigatonController ()<UIGestureRecognizerDelegate>

@end

@implementation HZNavigatonController

- (void)viewDidLoad {
    [super viewDidLoad];
    //开启右滑返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}


//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    if(UI_IS_IPAD){
//        return UIInterfaceOrientationMaskAll;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
//#endif
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
//
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    UIViewController* topVC = self.topViewController;
//    return [topVC preferredStatusBarStyle];
//}
@end
