//
//  Common.h
//  manualRotate
//
//  Created by hzy on 2018/7/29.
//  Copyright © 2018年 hzy. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//状态栏高度，iphoneX->44 其他 20
#define kStatusBar_Height [UIApplication sharedApplication].statusBarFrame.size.height
//底部安全距离 iphoneX->34 其他 0
#define kBottomSafeHeight (iPhoneX?34.0f:0.0f)
#define kRotateAnimationDuration 0.35f

#endif /* Common_h */
