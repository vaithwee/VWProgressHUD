//
//  VWBaseContentView+VWLoading.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWBaseContentView+VWLoading.h"
#import "VWConfig.h"

@implementation VWBaseContentView (VWLoading)
- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
{
    if (self = [self init])
    {
        
        [self setType:VWContentViewTypeLoading];
        
        /*创建loading*/
        UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView setColor:HEXCOLOR(LOADINGCOLOR)];
        [loadingView setHidesWhenStopped:YES];
        [self addSubview:loadingView];
        [loadingView startAnimating];
        self.topView = loadingView;
        
        if (ISSHOWDEFAULTTIP && (!tip || [tip isEqualToString:@""]))
        {
            tip = DEFAULTTIP;
        }
        
        [self.mainLabel setText:tip];
        [self.subLabel setText:sub];
        [self setConstraint];
        
        self.timer = [NSTimer timerWithTimeInterval:DELAYTIME target:[VWProgressHUD shareInstance] selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

- (void)setTip:(NSString *)tip sub:(NSString *)sub;
{
    [self.mainLabel setText:tip];
    [self.subLabel setText:sub];
    [self resetConstraint];
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:DELAYTIME target:[VWProgressHUD shareInstance] selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)toBeLoadingWithTip:(NSString *)tip sub:(NSString *)sub
{
    if (VWContentViewTypeLoading != self.type)
    {
        [self setType:VWContentViewTypeLoading];
        
        [self.topView removeFromSuperview];
        
        /*创建loading*/
        UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView setColor:HEXCOLOR(LOADINGCOLOR)];
        [loadingView setHidesWhenStopped:YES];
        [self addSubview:loadingView];
        [loadingView startAnimating];
        self.topView = loadingView;
        [self.mainLabel setText:tip];
        [self.subLabel setText:sub];
        [self setConstraint];
        [self.topView layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
        
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:DELAYTIME target:[VWProgressHUD shareInstance] selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}
@end
