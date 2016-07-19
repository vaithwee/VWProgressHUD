//
//  VWMsgContentView.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/19.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VWMsgType)
{
    VWMsgTypeDefault = 0,
    VWMsgTypeDone,
    VWMsgTypeFail,
    VWMsgTypeWarning,
};

@interface VWMsgContentView : UIView
- (instancetype)initWithMsg:(NSString *)msg type:(VWMsgType)type;
- (void)setMsg:(NSString *)msg type:(VWMsgType)type;
@end
