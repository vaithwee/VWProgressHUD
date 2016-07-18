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
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) UILabel *mainLabel;
@property (weak, nonatomic) UILabel *subLabel;
@end

@implementation VWLoadingView

- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
{
    if (self = [super init])
    {
        /*默认设置*/
        [self setBackgroundColor:HEXCOLOR(DMINANTCOLOR)];
        [self.layer setCornerRadius:5.f];
        [self setAlpha:LOADINGALPHA];
        
        /*创建loading*/
        UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView setColor:HEXCOLOR(LOADINGCOLOR)];
        [loadingView setHidesWhenStopped:YES];
        [self addSubview:loadingView];
        [loadingView addConstraint:NSLayoutAttributeWidth value:LOADINGWD*0.8];
        [loadingView addConstraint:NSLayoutAttributeHeight value:LOADINGWD*0.8];
        [loadingView addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
        [loadingView addConstraint:NSLayoutAttributeTop equalTo:self offset:LOADINGWD*0.1];
        [loadingView startAnimating];
        self.loadingView = loadingView;
        
        UIView *lastView = loadingView;
        
        if (ISSHOWDEFAULTTIP && (!tip || [tip isEqualToString:@""]))
        {
            tip = DEFAULTTIP;
        }
        
        /*main label*/
        if (tip && ![tip isEqualToString:@""])
        {
            UILabel *mainLabel = [UILabel new];
            [mainLabel setTextAlignment:NSTextAlignmentCenter];
            [mainLabel setText:tip];
            [mainLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
            [mainLabel setFont:[UIFont systemFontOfSize:DEFAULTTIPFONT]];
            [self addSubview:mainLabel];
            [mainLabel setPreferredMaxLayoutWidth:MAXTEXTWIDTH];
            [mainLabel setNumberOfLines:0];
            [mainLabel addConstraint:NSLayoutAttributeTop equalTo:loadingView fromConstraint:NSLayoutAttributeBottom offset:-PADDING];
            [mainLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
            [mainLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
            lastView = mainLabel;
            
            if (sub && ![sub isEqualToString:@""])
            {
                UILabel *subLabel = [UILabel new];
                [subLabel setTextAlignment:NSTextAlignmentCenter];
                [subLabel setText:sub];
                [subLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
                [subLabel setFont:[UIFont systemFontOfSize:DEFAULTSUBFONT]];
                [self addSubview:subLabel];
                [subLabel setPreferredMaxLayoutWidth:MAXTEXTWIDTH];
                [subLabel setNumberOfLines:0];
                [subLabel addConstraint:NSLayoutAttributeTop equalTo:mainLabel fromConstraint:NSLayoutAttributeBottom offset:PADDING/2];
                [subLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
                [subLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
                lastView = subLabel;
                
            }
        }

        
        [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationGreaterThanOrEqual value:LOADINGWD*(tip?1.2:1)];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:LOADINGWD*0.1]];
        
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview)
    {
        [self addConstraint:NSLayoutAttributeCenterX equalTo:self.superview offset:0];
        [self addConstraint:NSLayoutAttributeCenterY equalTo:self.superview offset:0];
    }
}
@end
