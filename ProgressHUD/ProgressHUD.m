//
//  ProgressHUD.m
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/9.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressHUD.h"
#import "ProgressHUDLoadingView.h"
#import "ProgressHUDConfigure.h"
#import "ProgressHUDTipView.h"

static ProgressHUD *_indicatorInstance;

typedef enum : NSUInteger {
    ProgressHUDStateStatic,
    ProgressHUDStateLoading,
    ProgressHUDStateAlert,
    ProgressHUDStateTip
} ProgressHUDState;

@interface ProgressHUD()
@property (assign, nonatomic) NSInteger loadingCount;
@property (assign, nonatomic) ProgressHUDState state;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ProgressHUDLoadingView *loadingView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIView *maskLayer;
@property (strong, nonatomic) ProgressHUDAlertView *alertView;
@property (strong, nonatomic) ProgressHUDTipView *tipView;
@end

@implementation ProgressHUD
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
        _state = ProgressHUDStateStatic;
        
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
- (ProgressHUDLoadingView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[ProgressHUDLoadingView alloc] initWithFrame:CGRectMake(0, 0, kProgressHUDContentWidth, kProgressHUDContentHeight)];
        [_loadingView setCenter:CGPointMake(kProgressWindowWidth/2, kProgressWindowHeight/2)];
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
    if (ProgressHUDStateLoading == _state)
    {
        _loadingCount += 1;
        [_timer invalidate];
        _timer = [NSTimer timerWithTimeInterval:kProgressHUDLoadingDelay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        return;
    }
    else if (ProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
    
    [_window setHidden:NO];
    [_window addSubview:self.loadingView];
    _state = ProgressHUDStateLoading;
    _loadingCount += 1;
    [_loadingView setTipText:tip];
    [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
        [_maskLayer setAlpha:1];
        [_loadingView setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished)
        {
            _timer = [NSTimer timerWithTimeInterval:kProgressHUDLoadingDelay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }];
}

#pragma mark - AlertView
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id/*<ProgressHUDAlertViewDelegate>*/)delegate alertStyle:(ProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (ProgressHUDStateLoading == _state)
    {
        [_timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        _loadingCount = 0;
    }
    else if(ProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
    }
    
    _state = ProgressHUDStateAlert;
    _alertView = [[ProgressHUDAlertView alloc] initWithTitle:title message:message delegate:delegate alertViewStyle:alertStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [_window addSubview:_alertView];
    [_window setHidden:NO];
    [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
        [_maskLayer setAlpha:1];
        [_alertView setAlpha:1];
    }];
    
}

#pragma mark -TipView
#pragma mark 显示提示
- (void)showTip:(NSString *)tip
{
    return [self showTip:tip type:ProgressHUDTipTypeSucceed completion:nil];
}

- (void)showErrorTip:(NSString *)tip
{
    return [self showTip:tip type:ProgressHUDTipTypeError completion:nil];
}

- (void)showWarningTip:(NSString *)tip
{
    return [self showTip:tip type:ProgressHUDTipTypeWarning completion:nil];
}

- (void)showDoneTip:(NSString *)tip
{
    return [self showTip:tip type:ProgressHUDTipTypeDone completion:nil];
}

- (void)showTip:(NSString *)tip type:(ProgressHUDTipType)type completion:(void (^)(void))completion;
{
    if (ProgressHUDStateLoading == _state)
    {
        [_timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        _loadingCount = 0;
    }
    else if(ProgressHUDStateAlert == _state)
    {
        [_alertView removeFromSuperview];
    }
    
    _state = ProgressHUDStateTip;
    [_maskLayer setAlpha:0];
    
    _tipView = [[ProgressHUDTipView alloc] initWithTip:tip tipType:type];

    [_window addSubview:_tipView];
    [_window setHidden:NO];
    [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
        [_tipView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kProgressHUDAnimationDuration delay:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [_tipView setAlpha:0];
        } completion:^(BOOL finished) {
            [_tipView removeFromSuperview];
            _tipView = nil;
            [_window setHidden:YES];
            _state = ProgressHUDStateStatic;
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
    if (ProgressHUDStateAlert == _state)
    {
        [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
            [_maskLayer setAlpha:0];
            [_alertView setAlpha:0];
        } completion:^(BOOL finished) {
            [_window setHidden:YES];
            [_alertView removeFromSuperview];
            _alertView = nil;
        }];
        _state = ProgressHUDStateStatic;
    }
}

#pragma mark 消失
- (void)dismiss
{
    NSLog(@"Dismiss LoadingCount:%ld", (long)_loadingCount);
    if (_state == ProgressHUDStateStatic)
    {
        return;
    }
    else if (_state == ProgressHUDStateLoading)
    {
        if (--_loadingCount)
        {
            return;
        }
    }
    
    switch (_state)
    {
        case ProgressHUDStateLoading:
        {
            [_timer invalidate];
            _loadingCount = 0;
            [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
                [_maskLayer setAlpha:0];
                [_loadingView setAlpha:0];
            } completion:^(BOOL finished) {
                [_window setHidden:YES];
                [_loadingView removeFromSuperview];
            }];
            break;
        }
        case ProgressHUDStateAlert:
        {
            [UIView animateWithDuration:kProgressHUDAnimationDuration animations:^{
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
    _state = ProgressHUDStateStatic;
}
@end
