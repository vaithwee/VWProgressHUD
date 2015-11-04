//
//  SMProgressHUD.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/9.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMProgressHUD.h"
#import "SMProgressHUDLoadingView.h"
#import "SMProgressHUDConfigure.h"
#import "SMProgressHUDTipView.h"

static SMProgressHUD *_indicatorInstance;

typedef enum : NSUInteger {
    SMProgressHUDStateStatic,
    SMProgressHUDStateLoading,
    SMProgressHUDStateAlert,
    SMProgressHUDStateTip
} SMProgressHUDState;

@interface SMProgressHUD()
{
 NSInteger loadingCount;
 SMProgressHUDState state;
 UIWindow *window;
NSTimer *timer;
UIView *maskLayer;
}
@property (strong, nonatomic) SMProgressHUDLoadingView *loadingView;
@property (strong, nonatomic) SMProgressHUDAlertView *alertView;
@property (strong, nonatomic) SMProgressHUDTipView *tipView;
@end

@implementation SMProgressHUD
+(instancetype)shareInstancetype
{
    if (nil == _indicatorInstance) {
        _indicatorInstance = [[super allocWithZone:NULL] init];
    }
    return  _indicatorInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicatorInstance = [super allocWithZone:zone];
    });
    return _indicatorInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        state = SMProgressHUDStateStatic;
        
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window setBackgroundColor:[UIColor clearColor]];
        [window setWindowLevel:UIWindowLevelAlert];
        [window makeKeyAndVisible];
        [window setHidden:YES];
        
        maskLayer = [[UIView alloc] initWithFrame:window.bounds];
        [maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [maskLayer setAlpha:0];
        [window addSubview:maskLayer];
        
    }
    return self;
}

#pragma mark - LoadingView
#pragma mark 获取loadingview
- (SMProgressHUDLoadingView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[SMProgressHUDLoadingView alloc] initWithFrame:CGRectMake(0, 0, kSMProgressHUDContentWidth, kSMProgressHUDContentHeight)];
        [_loadingView setCenter:CGPointMake(kSMProgressWindowWidth/2, kSMProgressWindowHeight/2)];
    }
    [_loadingView setAlpha:0];
    return _loadingView;
}

- (void)showLoading
{
    return [self showLoadingWithTip:nil];
}

- (void)showLoadingWithTip:(NSString *)tip
{
    if (SMProgressHUDStateLoading == state)
    {
        loadingCount += 1;
        [timer invalidate];
        timer = [NSTimer timerWithTimeInterval:kSMProgressHUDLoadingDelay target:self selector:@selector(dismissLoadingView) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        return;
    }
    else if (SMProgressHUDStateAlert == state)
    {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
    
    [window setHidden:NO];
    [window addSubview:self.loadingView];
    state = SMProgressHUDStateLoading;
    loadingCount += 1;
    [_loadingView setTipText:tip];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:1];
        [_loadingView setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished)
        {
            timer = [NSTimer timerWithTimeInterval:kSMProgressHUDLoadingDelay target:self selector:@selector(dismissLoadingView) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}

#pragma mark - AlertView
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id/*<SMProgressHUDAlertViewDelegate>*/)delegate alertStyle:(SMProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (SMProgressHUDStateLoading == state)
    {
        [timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        loadingCount = 0;
    }
    else if(SMProgressHUDStateAlert == state)
    {
        [_alertView removeFromSuperview];
    }
    
    state = SMProgressHUDStateAlert;
    _alertView = [[SMProgressHUDAlertView alloc] initWithTitle:title message:message delegate:delegate alertViewStyle:alertStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [window addSubview:_alertView];
    [window setHidden:NO];
    [window setUserInteractionEnabled:YES];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:1];
        [_alertView setAlpha:1];
    }];
    
}

#pragma mark -TipView
#pragma mark 显示提示
- (void)showTip:(NSString *)tip
{
    return [self showTip:tip type:SMProgressHUDTipTypeSucceed completion:nil];
}

- (void)showErrorTip:(NSString *)tip
{
    return [self showTip:tip type:SMProgressHUDTipTypeError completion:nil];
}

- (void)showWarningTip:(NSString *)tip
{
    return [self showTip:tip type:SMProgressHUDTipTypeWarning completion:nil];
}

- (void)showDoneTip:(NSString *)tip
{
    return [self showTip:tip type:SMProgressHUDTipTypeDone completion:nil];
}

- (void)showTip:(NSString *)tip type:(SMProgressHUDTipType)type completion:(void (^)(void))completion;
{
    if (SMProgressHUDStateLoading == state)
    {
        [timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        loadingCount = 0;
    }
    else if(SMProgressHUDStateAlert == state)
    {
        [_alertView removeFromSuperview];
    }
    else if (SMProgressHUDStateTip == state)
    {
        return;
    }
    
    state = SMProgressHUDStateTip;
    [maskLayer setAlpha:0];
    
    _tipView = [[SMProgressHUDTipView alloc] initWithTip:tip tipType:type];

    [window addSubview:_tipView];
    [window setHidden:NO];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [_tipView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration delay:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [_tipView setAlpha:0];
        } completion:^(BOOL finished) {
            [_tipView removeFromSuperview];
            _tipView = nil;
            [window setHidden:YES];
            state = SMProgressHUDStateStatic;
            if (completion)
            {
                completion();
            }
        }];
    }];
}


#pragma mark - 消失方法
- (void)dismissLoadingView
{
    NSLog(@"SMProgress-LoadingCount: %d", loadingCount);
    if (state != SMProgressHUDStateLoading || --loadingCount)
    {
        return;
    }
    
    [timer invalidate];
    loadingCount = 0;
    state = SMProgressHUDStateStatic;
    [window setHidden:YES];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:0];
        [_loadingView setAlpha:0];
    } completion:^(BOOL finished) {
        [window setHidden:YES];
        [_loadingView removeFromSuperview];
    }];
    
}

- (void)dismissAlertView
{
    if (SMProgressHUDStateAlert == state)
    {
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
            [maskLayer setAlpha:0];
            [_alertView setAlpha:0];
        } completion:^(BOOL finished) {
            [window setHidden:YES];
            [_alertView removeFromSuperview];
            _alertView = nil;
        }];
        state = SMProgressHUDStateStatic;
    }
}

#pragma mark 消失
- (void)dismiss
{
    
}
@end
