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
@property (assign, nonatomic) NSInteger loadingCount;
@property (assign, nonatomic) SMProgressHUDState state;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SMProgressHUDLoadingView *loadingView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIView *maskLayer;
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
        _state = SMProgressHUDStateStatic;
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window setBackgroundColor:[UIColor clearColor]];
        [_window setWindowLevel:UIWindowLevelAlert];
        [_window makeKeyAndVisible];
        [_window setHidden:YES];
        
        _maskLayer = [[UIView alloc] initWithFrame:_window.bounds];
        [_maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [_maskLayer setAlpha:0];
        [_window addSubview:_maskLayer];
        
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
    if (SMProgressHUDStateLoading == _state)
    {
        _loadingCount += 1;
        [_timer invalidate];
        _timer = [NSTimer timerWithTimeInterval:kSMProgressHUDLoadingDelay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        return;
    }
    else if (SMProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
    
    [_window setHidden:NO];
    [_window addSubview:self.loadingView];
    _state = SMProgressHUDStateLoading;
    _loadingCount += 1;
    [_loadingView setTipText:tip];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [_maskLayer setAlpha:1];
        [_loadingView setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished)
        {
            _timer = [NSTimer timerWithTimeInterval:kSMProgressHUDLoadingDelay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }];
}

#pragma mark - AlertView
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id/*<SMProgressHUDAlertViewDelegate>*/)delegate alertStyle:(SMProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (SMProgressHUDStateLoading == _state)
    {
        [_timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        _loadingCount = 0;
    }
    else if(SMProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
    }
    
    _state = SMProgressHUDStateAlert;
    _alertView = [[SMProgressHUDAlertView alloc] initWithTitle:title message:message delegate:delegate alertViewStyle:alertStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [_window addSubview:_alertView];
    [_window setHidden:NO];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [_maskLayer setAlpha:1];
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
    if (SMProgressHUDStateLoading == _state)
    {
        [_timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        _loadingCount = 0;
    }
    else if(SMProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
    }
    
    _state = SMProgressHUDStateTip;
    [_maskLayer setAlpha:0];
    
    _tipView = [[SMProgressHUDTipView alloc] initWithTip:tip tipType:type];

    [_window addSubview:_tipView];
    [_window setHidden:NO];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [_tipView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration delay:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [_tipView setAlpha:0];
        } completion:^(BOOL finished) {
            [_tipView removeFromSuperview];
            _tipView = nil;
            [_window setHidden:YES];
            _state = SMProgressHUDStateStatic;
            if (completion)
            {
                completion();
            }
        }];
    }];
}

#pragma mark 清理
- (void)cleanAllView
{
    
}

- (void)alertViewDismiss
{
    if (SMProgressHUDStateAlert == _state)
    {
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
            [_maskLayer setAlpha:0];
            [_alertView setAlpha:0];
        } completion:^(BOOL finished) {
            [_window setHidden:YES];
            [_alertView removeFromSuperview];
            _alertView = nil;
        }];
        _state = SMProgressHUDStateStatic;
    }
}

#pragma mark 消失
- (void)dismiss
{
    NSLog(@"Dismiss LoadingCount:%ld", (long)_loadingCount);
    if (_state == SMProgressHUDStateStatic)
    {
        return;
    }
    else if (_state == SMProgressHUDStateLoading)
    {
        if (--_loadingCount)
        {
            return;
        }
    }
    
    switch (_state)
    {
        case SMProgressHUDStateLoading:
        {
            [_timer invalidate];
            _loadingCount = 0;
            [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
                [_maskLayer setAlpha:0];
                [_loadingView setAlpha:0];
            } completion:^(BOOL finished) {
                [_window setHidden:YES];
                [_loadingView removeFromSuperview];
            }];
            break;
        }
        case SMProgressHUDStateAlert:
        {
            [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
                [_maskLayer setAlpha:0];
                [_alertView setAlpha:0];
            } completion:^(BOOL finished) {
                [_window setHidden:YES];
                [_alertView removeFromSuperview];
                _alertView = nil;
            }];
            break;
        }
        default:
            break;
    }
    _state = SMProgressHUDStateStatic;
}
@end
