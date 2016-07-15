//
//  VWProgressHUDManager.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/15.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWProgressHUDManager.h"

static VWProgressHUD *_shareInstance;

@interface VWProgressHUD ()
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *currentView;
@property (weak, nonatomic) UIView *firstResponder;
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

        /*regist notification*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

        /*test code*/


        NSLog(@"progress hud init cpx");
    }
    return self;
}

#pragma mark config
+ (void)configure
{
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
- (void)keyboardWasShown:(NSNotification *)notification
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];

    NSLog(@"%@",firstResponder);
    self.firstResponder = firstResponder;
    NSLog(@"keyboard show");
}

#pragma mark keyboard hidden
- (void)keyboardWasHidden:(NSNotification *)notification
{
    self.firstResponder = nil;
    NSLog(@"keyboard hidden");
}

#pragma mark - Commen Method
- (void)initConfig
{
    /*clean keyboard*/
   if ([self.firstResponder respondsToSelector:@selector(resignFirstResponder)])
   {
       [self.firstResponder performSelector:@selector(resignFirstResponder)];
   }
}

- (void)showLoading
{
    [self initConfig];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.window addSubview:view];
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    self.currentView = view;
}
@end
