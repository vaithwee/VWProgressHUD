//
//  VWProgressHUDManager.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/15.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWProgressHUD : NSObject
+ (void)log;

#pragma mark config
+ (void)configure;

#pragma mark create instance
+ (instancetype)shareInstance;

- (void)dismiss;

#pragma mark show loading;
- (void)showLoading;
- (void)showLoadingWithTip:(NSString *)tip;
- (void)showLoadingWithTip:(NSString *)tip sub:(NSString *)sub;
@end
