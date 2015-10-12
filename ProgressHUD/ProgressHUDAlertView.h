//
//  ProgressHUDAlertView.h
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressHUDAlertView;

typedef void (^AlertViewCompletion)(ProgressHUDAlertView *alertView, NSInteger buttonIndex);

typedef NS_ENUM(NSInteger,ProgressHUDAlertViewStyle)
{
    ProgressHUDAlertViewStyleDefault = 0,
    ProgressHUDAlertViewStyleSecureTextInput,
    ProgressHUDAlertViewStylePlainTextInput,
    ProgressHUDAlertViewStyleLoginAndPasswordInput
};

@protocol ProgressHUDAlertViewDelegate <NSObject>
- (void)alertView:(ProgressHUDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface ProgressHUDAlertView : UIView
@property (nonatomic, strong, readonly) UITextField *plainTextInput;
@property (nonatomic, strong, readonly) UITextField *secureTextInput;
@property (weak, nonatomic) id<ProgressHUDAlertViewDelegate> delegate;
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id/*<ProgressHUDAlertViewDelegate>*/)delegate alertViewStyle:(ProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
@end
