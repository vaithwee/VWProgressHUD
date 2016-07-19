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
@property (assign, nonatomic) BOOL isNeedAni;
@end

@implementation VWLoadingView

- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
{
    if (self = [super init])
    {
        /*默认设置*/
        [self setBackgroundColor:HEXCOLOR(DMINANTCOLOR)];
        [self setAlpha:LOADINGALPHA];
        [self.layer setCornerRadius:5.f];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowOpacity:0.2f];


        /*创建loading*/
        UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView setColor:HEXCOLOR(LOADINGCOLOR)];
        [loadingView setHidesWhenStopped:YES];
        [self addSubview:loadingView];
        [loadingView startAnimating];
        self.loadingView = loadingView;
        
        if (ISSHOWDEFAULTTIP && (!tip || [tip isEqualToString:@""]))
        {
            tip = DEFAULTTIP;
        }
        
        UILabel *mainLabel = [UILabel new];
        [mainLabel setTextAlignment:NSTextAlignmentCenter];
        [mainLabel setText:tip];
        [mainLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [mainLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
        [mainLabel setFont:[UIFont systemFontOfSize:DEFAULTTIPFONT]];
        [self addSubview:mainLabel];
        [mainLabel setPreferredMaxLayoutWidth:MAXTEXTWIDTH];
        [mainLabel setNumberOfLines:0];
        self.mainLabel = mainLabel;
        
        UILabel *subLabel = [UILabel new];
        [subLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [subLabel setTextAlignment:NSTextAlignmentCenter];
        [subLabel setText:sub];
        [subLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
        [subLabel setFont:[UIFont systemFontOfSize:DEFAULTSUBFONT]];
        [self addSubview:subLabel];
        [subLabel setPreferredMaxLayoutWidth:MAXTEXTWIDTH];
        [subLabel setNumberOfLines:0];
        self.subLabel = subLabel;
        
        [self setConstraint];
        
    }
    return self;
}

- (void)setTip:(NSString *)tip sub:(NSString *)sub;
{
    [self.mainLabel setText:tip];
    [self.subLabel setText:sub];
    [self setIsNeedAni:YES];
    [self setConstraint];
}

- (void)setConstraint
{
    [self removeAllAutoLayout];
    
    [self.loadingView addConstraint:NSLayoutAttributeWidth value:LOADINGWD*0.8];
    [self.loadingView addConstraint:NSLayoutAttributeHeight value:LOADINGWD*0.8];
    [self.loadingView addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
    [self.loadingView addConstraint:NSLayoutAttributeTop equalTo:self offset:LOADINGWD*0.1];
    
    [self.mainLabel addConstraint:NSLayoutAttributeTop equalTo:self.loadingView fromConstraint:NSLayoutAttributeBottom offset:-PADDING];
    [self.mainLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
    [self.mainLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
    
    [self.subLabel addConstraint:NSLayoutAttributeTop equalTo:self.mainLabel fromConstraint:NSLayoutAttributeBottom offset:PADDING/2];
    [self.subLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
    [self.subLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
    
    UIView *lastView = self.loadingView;
    lastView = self.mainLabel.text.length>0?self.mainLabel:lastView;
    lastView = self.subLabel.text.length>0?self.subLabel:lastView;
    [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationGreaterThanOrEqual value:LOADINGWD];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:LOADINGWD*0.1]];
    
    if (self.isNeedAni)
    {
        self.isNeedAni = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            [self.loadingView layoutIfNeeded];
            [self.mainLabel layoutIfNeeded];
            [self.subLabel layoutIfNeeded];
        }];
    }

    
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
