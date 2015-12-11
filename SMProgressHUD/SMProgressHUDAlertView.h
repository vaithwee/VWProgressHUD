//
//  SMProgressHUDAlertView.h
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMProgressHUDAlertView;

#pragma mark Alert类型
typedef NS_ENUM(NSInteger,SMProgressHUDAlertViewStyle)
{
    SMProgressHUDAlertViewStyleDefault = 0,
    SMProgressHUDAlertViewStyleSecureTextInput,
    SMProgressHUDAlertViewStylePlainTextInput,
    SMProgressHUDAlertViewStyleLoginAndPasswordInput
};

#pragma mark 代理方法
@protocol SMProgressHUDAlertViewDelegate <NSObject>
@optional
- (void)alertView:(SMProgressHUDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertView:(SMProgressHUDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex userInfo:(NSDictionary *)userInfo;
@end

@interface SMProgressHUDAlertView : UIView
@property (strong, nonatomic) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) UITextField *plainTextInput;
@property (nonatomic, strong, readonly) UITextField *secureTextInput;
@property (weak, nonatomic) id<SMProgressHUDAlertViewDelegate> delegate;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<SMProgressHUDAlertViewDelegate>)delegate alertViewStyle:(SMProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
@end
