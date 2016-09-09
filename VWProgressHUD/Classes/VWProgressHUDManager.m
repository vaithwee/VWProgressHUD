//
//  VWProgressHUDManager.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/15.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWProgressHUDManager.h"
#import "VWConfig.h"
#import <UIKit/UIKit.h>
#import "VWBaseContentView.h"
#import "VWBaseContentView+VWMessage.h"
#import "VWBaseContentView+VWLoading.h"

static VWProgressHUD *_shareInstance;

@interface VWProgressHUD ()
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *firstResponder;
@property (assign, nonatomic) NSInteger loadingCount;
@property (weak, nonatomic) VWBaseContentView *currentView;
@end

@implementation VWProgressHUD
#pragma mark create instance

+ (instancetype)shareInstance {
    if (nil == _shareInstance) {
        _shareInstance = [[super allocWithZone:NULL] init];
    }
    return _shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    return _shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        /*create window*/
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
        [window setBackgroundColor:[UIColor clearColor]];
        [window setWindowLevel:UIWindowLevelAlert + 100];
        [window setUserInteractionEnabled:NO];
        [window setRootViewController:[UIViewController new]];
        self.window = window;
        
        /*regist screen change and keyboard notification*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:kVWDismissNotification object:nil];
        
    }
    return self;
}

#pragma mark config
+ (void)configure {
    [self shareInstance];
}

#pragma mark - Notification Method
#pragma mark screen change notification by status bar

- (void)statusBarOrientationChange:(NSNotification *)notification {
    /*change current view center*/

    NSLog(@"screen has change");
}

#pragma mark keyborard show

- (void)keyboardWasShown:(NSNotification *)notification {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    NSLog(@"%@", firstResponder);
    self.firstResponder = firstResponder;
    NSLog(@"keyboard show");
}

#pragma mark keyboard hidden

- (void)keyboardWasHidden:(NSNotification *)notification {
    self.firstResponder = nil;
    NSLog(@"keyboard hidden");
}

#pragma mark - Commen Method
#pragma mark init and clean

- (void)initConfig {
    /*clean keyboard*/
    if ([self.firstResponder respondsToSelector:@selector(resignFirstResponder)]) {
        [self.firstResponder performSelector:@selector(resignFirstResponder)];
    }
}

#pragma mark dismiss
- (void)dismiss
{
    [self.window setUserInteractionEnabled:NO];
    if (self.currentView)
    {
        [self.currentView dismiss];
        self.currentView = nil;
    }
}

#pragma mark show loading;

- (void)showLoading
{
    return [self showLoadingWithTip:nil sub:nil];
}

- (void)showLoadingWithTip:(NSString *)tip
{
    return [self showLoadingWithTip:tip sub:nil];
}

- (void)showLoadingWithTip:(NSString *)tip sub:(NSString *)sub
{
    [self.window setUserInteractionEnabled:YES];
    if (self.currentView && VWContentViewTypeLoading == self.currentView.type)
    {
        [self.currentView setTip:tip sub:sub];
        return;
    }else if (self.currentView && VWContentViewTypeMessage == self.currentView.type)
    {
        [self.currentView toBeLoadingWithTip:tip sub:sub];
        return;
    }

    VWBaseContentView  *view = [[VWBaseContentView alloc] initWithTip:tip sub:sub];
    [self.window addSubview:view];
    self.currentView = view;
    

}

- (void)showMsg:(NSString *)msg
{
    return [self showMsg:msg type:VWMsgTypeDefault];
}

- (void)showDoneMsg:(NSString *)msg
{
    return [self showMsg:msg type:VWMsgTypeDone];
}

- (void)showFailMsg:(NSString *)msg
{
    return [self showMsg:msg type:VWMsgTypeFail];
}

- (void)showWarningMsg:(NSString *)msg
{
    return [self showMsg:msg type:VWMsgTypeWarning];
}

- (void)showMsg:(NSString *)msg type:(VWMsgType)type
{
    [self.window setUserInteractionEnabled:NO];
    if (self.currentView && self.currentView.type == VWContentViewTypeLoading)
    {
        [self.currentView toBeMessageWithMsg:msg type:type];
        return;
    } else if (self.currentView && self.currentView.type == VWContentViewTypeMessage) {
        [self.currentView setMsg:msg type:type];
        return;
    }

    VWBaseContentView *msgView = [[VWBaseContentView alloc] initWithMsg:msg type:type];
    [self.window addSubview:msgView];
    self.currentView = msgView;

}

@end
