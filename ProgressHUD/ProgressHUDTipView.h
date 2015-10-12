//
//  ProgressHUDTipView.h
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProgressHUDTipType)
{
    ProgressHUDTipTypeSucceed = 0,
    ProgressHUDTipTypeDone,
    ProgressHUDTipTypeError,
    ProgressHUDTipTypeWarning
};

@interface ProgressHUDTipView : UIView
-(instancetype)initWithTip:(NSString *)tip tipType:(ProgressHUDTipType)type;
@end
