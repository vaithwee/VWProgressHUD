//
//  VWLoadingView.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWLoadingView.h"
#import "VWConfig.h"
#import "UIView+VWAutolayout.h"

@interface VWLoadingView()
@end

@implementation VWLoadingView

- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
{
    if (self = [super init])
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
        
    }
    return self;
}

- (void)setTip:(NSString *)tip sub:(NSString *)sub;
{
    [self.mainLabel setText:tip];
    [self.subLabel setText:sub];
    [self resetConstraint];
}
@end
