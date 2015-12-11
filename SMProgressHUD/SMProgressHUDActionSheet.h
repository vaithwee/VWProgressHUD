//
//  SMProgressHUDActionSheet.h
//  SMProgressHUD
//
//  Created by OrangeLife on 15/12/10.
//  Copyright © 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMProgressHUDActionSheet;
@protocol SMProgressHUDActionSheetDelegate <NSObject>

@optional
-(void)actionSheetView:(SMProgressHUDActionSheet*)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)actionSheetView:(SMProgressHUDActionSheet*)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex userInfo:(NSDictionary *)userInfo;

@end

@interface SMProgressHUDActionSheet : UIView
- (instancetype)initWithTitle:(NSString *)title delegate:(id<SMProgressHUDActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles userInfo:(NSDictionary *)userinfo;
- (void)show;
- (void)hide;
- (void)remove;
@end
