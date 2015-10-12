//
//  ProgressHUDConfigure.h
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/10.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef ProgressHUD_ProgressHUDConfigure_h
#define ProgressHUD_ProgressHUDConfigure_h

#define kProgressWindowWidth [UIScreen mainScreen].bounds.size.width
#define kProgressWindowHeight [UIScreen mainScreen].bounds.size.height

static const NSTimeInterval kProgressHUDLoadingDelay = 30.f;
static const NSTimeInterval kProgressHUDAnimationDuration = 0.3f;

static const CGFloat kProgressHUDCornerRadius = 5.f;
static const CGFloat  kProgressHUDLoadingIconWH = 30.f;
static const CGFloat  kProgressHUDContentWidth = 200.f;
static const CGFloat  kProgressHUDContentHeight = 100.f;
static const CGFloat kProgressHUDAlertViewWidth = 280.f;

static NSString *ProgressHUDLoadingTip = @"正在加载中...";

#endif
