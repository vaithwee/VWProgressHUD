//
//  VWProgressHUDManager.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/15.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWProgressHUDManager.h"
#import "VWConfig.h"
#import "VWLoadingView.h"
#import <UIKit/UIKit.h>
#import <VWMsgContentView.h>

static VWProgressHUD *_shareInstance;

@interface VWProgressHUD ()
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *currentView;
@property (weak, nonatomic) UIView *firstResponder;
@property (assign, nonatomic) NSInteger loadingCount;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) VWLoadingView *loadingView;
@property (weak, nonatomic) VWMsgContentView *msgContentView;
@end

@implementation VWProgressHUD
+ (void)log {
    NSLog(@"test log");
}

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
    if (self.currentView) {
        [self.currentView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2)];
    }
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
    [UIView animateWithDuration:0.25 animations:^{
        [self.loadingView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.window setUserInteractionEnabled:NO];
        [self.loadingView removeFromSuperview];
        [self.timer invalidate];
        self.timer = nil;
    }];
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
    
    if (self.loadingView)
    {
        [self.loadingView setTip:tip sub:sub];
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:DELAYTIME target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        return;
    }
    
    [self.window setUserInteractionEnabled:YES];
    
    VWLoadingView  *view = [[VWLoadingView alloc] initWithTip:tip sub:sub];
    [self.window addSubview:view];
    self.loadingView = view;
    
    self.timer = [NSTimer timerWithTimeInterval:DELAYTIME target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
    if (self.msgContentView)
    {
        [self.msgContentView setMsg:msg type:type];
        [UIView animateWithDuration:10  animations:^{
            [self.msgContentView layoutIfNeeded];
        }];
        return;;
    }

    VWMsgContentView *msgView = [[VWMsgContentView alloc] initWithMsg:msg type:type];
    [self.window addSubview:msgView];
    self.msgContentView = msgView;

    [UIView animateWithDuration:10  animations:^{
        [msgView setAlpha:LOADINGALPHA];
    }];

    [UIView animateWithDuration:0.25 delay:kVWMESDELAYTIME options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [msgView setAlpha:0];
    } completion:^(BOOL finished) {
        [msgView removeFromSuperview];
    }];
}
@end
