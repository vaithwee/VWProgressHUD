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
#import "UIView+SMAutolayout.h"

static SMProgressHUD *_indicatorInstance;

typedef enum : NSUInteger {
    SMProgressHUDStateStatic,
    SMProgressHUDStateLoading,
    SMProgressHUDStateAlert,
    SMProgressHUDStateTip,
    SMProgressHUDStateActionSheet,
} SMProgressHUDState;

@interface SMProgressHUD()
{
    NSInteger loadingCount;
    SMProgressHUDState state;
    UIWindow *window;
    NSTimer *timer;
    UIView *maskLayer;
    NSOperationQueue *queue;
}
@property (strong, nonatomic) SMProgressHUDLoadingView *loadingView;
@property (strong, nonatomic) SMProgressHUDAlertView *alertView;
@property (strong, nonatomic) SMProgressHUDTipView *tipView;
@property (strong, nonatomic) SMProgressHUDActionSheet *actionSheetView;
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
        [window setWindowLevel:UIWindowLevelAlert+100];
        [window makeKeyAndVisible];
        [window setHidden:YES];
        
        maskLayer = [[UIView alloc] initWithFrame:window.bounds];
        [maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [maskLayer setAlpha:0];
        [window addSubview:maskLayer];
        
        queue = [[NSOperationQueue alloc] init];
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
    else if (SMProgressHUDStateActionSheet == state)
    {
        [_actionSheetView remove];
        _actionSheetView = nil;
    }
    else if (SMProgressHUDStateTip == state)
    {
        [_tipView removeFromSuperview];
        _tipView = nil;
    }
    
    [window setHidden:NO];
    [window addSubview:self.loadingView];
    [window setFrame:CGRectMake(0, 0, kSMProgressWindowWidth, kSMProgressWindowHeight)];
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
- (void)setAlertViewTag:(NSUInteger)tag
{
    [_alertView setTag:tag];
}
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<SMProgressHUDAlertViewDelegate>)delegate alertStyle:(SMProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    return [self showAlertWithTitle:title message:message delegate:delegate alertStyle:alertStyle userInfo:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<SMProgressHUDAlertViewDelegate>)delegate alertStyle:(SMProgressHUDAlertViewStyle)alertStyle userInfo:(NSDictionary *)userInfo cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    //清除状态
    if (SMProgressHUDStateLoading == state)
    {
        [timer invalidate];
        [_loadingView setAlpha:0];
        [_loadingView removeFromSuperview];
        loadingCount = 0;
    }
    else if (SMProgressHUDStateActionSheet == state)
    {
        [_actionSheetView remove];
        _actionSheetView = nil;
    }
    else if(SMProgressHUDStateAlert == state)
    {
        [_alertView removeFromSuperview];
    }
    else if (SMProgressHUDStateTip == state)
    {
        [_tipView removeFromSuperview];
        _tipView = nil;
    }
    
    //创建AlertView
    state = SMProgressHUDStateAlert;
    _alertView = [[SMProgressHUDAlertView alloc] initWithTitle:title message:message delegate:delegate alertViewStyle:alertStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [_alertView setUserInfo:userInfo];
    [maskLayer addSubview:_alertView];
    [window setHidden:NO];
    [window setFrame:CGRectMake(0, 0, kSMProgressWindowWidth, kSMProgressWindowHeight)];
    
    //动画
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:1];
        [_alertView setAlpha:1];
    }];
}

#pragma mark - ActionSheet
- (void)setActionSheetTag:(NSInteger)tag
{
    [_actionSheetView setTag:tag];
}

- (void)showActionSheetWithTitle:(NSString *)title delegate:(id<SMProgressHUDActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    return [self showActionSheetWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles userInfo:nil];
}

- (void)showActionSheetWithTitle:(NSString *)title delegate:(id<SMProgressHUDActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles userInfo:(NSDictionary *)userInfo
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
        [_tipView removeFromSuperview];
        _tipView = nil;
    }
    else if(SMProgressHUDStateActionSheet == state)
    {
        return;
    }
    
    state = SMProgressHUDStateActionSheet;
    _actionSheetView = [[SMProgressHUDActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles userInfo:userInfo];
    [window setHidden:NO];
    [window setFrame:CGRectMake(0, 0, kSMProgressWindowWidth, kSMProgressWindowHeight)];
    
    [maskLayer setAlpha:1];
    [window  addSubview:_actionSheetView];
    [_actionSheetView show];
}

#pragma mark - TipView
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
    else if (SMProgressHUDStateActionSheet == state)
    {
        [_actionSheetView remove];
        _actionSheetView = nil;
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
    [window setFrame:_tipView.bounds];
    [window setCenter:CGPointMake(kSMProgressWindowWidth/2, kSMProgressWindowHeight/2)];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [_tipView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration delay:1.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [_tipView setAlpha:0];
        } completion:^(BOOL finished) {
            [_tipView removeFromSuperview];
            _tipView = nil;
            if(SMProgressHUDStateTip == state)
            {
                [window setHidden:YES];
                state = SMProgressHUDStateStatic;
                if (completion)
                {
                    completion();
                }}
        }];
    }];
}



#pragma mark - 清除
#pragma mark 重置状态
- (void)resetState:(SMProgressHUDState)s
{
    if (s == state)
    {
        return;
    }
    else if (SMProgressHUDStateLoading == state)
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
    else if (SMProgressHUDStateTip == state)
    {
        [_tipView removeFromSuperview];
        _tipView = nil;
    }
}

- (void)dismissLoadingView
{
    NSLog(@"SMProgress-LoadingCount: %ld", (long)loadingCount);
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

- (void)dismissActionSheet
{
    if (SMProgressHUDStateActionSheet == state)
    {
        [_actionSheetView hide];
        [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
            [maskLayer setAlpha:0];
            [_alertView setAlpha:0];
            [_actionSheetView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [window setHidden:YES];
            [_actionSheetView removeFromSuperview];
            _actionSheetView = nil;
        }];
        state = SMProgressHUDStateStatic;
    }
}

#pragma mark 消失
- (void)dismiss
{
    
}
@end
