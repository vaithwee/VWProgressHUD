//
//  VWBaseContentView+VWLoading.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <VWProgressHUD/VWProgressHUD.h>
#import "VWEnum.h"

@interface VWBaseContentView (VWLoading)
- (instancetype)initWithMsg:(NSString *)msg type:(VWMsgType)type;
- (void)setMsg:(NSString *)msg type:(VWMsgType)type;
@end
