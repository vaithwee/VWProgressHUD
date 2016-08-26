//
//  VWEnum.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, VWMsgType)
{
    VWMsgTypeDefault = 0,
    VWMsgTypeDone,
    VWMsgTypeFail,
    VWMsgTypeWarning,
};



typedef NS_ENUM(NSInteger, VWContentViewType)
{
    VWContentViewTypeLoading,
    VWContentViewTypeMessage
};
