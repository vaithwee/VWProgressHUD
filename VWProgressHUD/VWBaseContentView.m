//
//  VWBaseContentView.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/19.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWBaseContentView.h"
#import "UIView+VWAutolayout.h"
#import "VWConfig.h"

@interface VWBaseContentView()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation VWBaseContentView

- (instancetype)init
{
    if (self = [super init])
    {
        [self setBackgroundColor:HEXCOLOR(DMINANTCOLOR)];
        [self.layer setCornerRadius:5.f];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowOpacity:0.2f];
        [self setAlpha:0];
        
        UILabel *mainLabel = [UILabel new];
        [mainLabel setTextAlignment:NSTextAlignmentCenter];
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
        [subLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
        [subLabel setFont:[UIFont systemFontOfSize:DEFAULTSUBFONT]];
        [self addSubview:subLabel];
        [subLabel setPreferredMaxLayoutWidth:MAXTEXTWIDTH];
        [subLabel setNumberOfLines:0];
        self.subLabel = subLabel;
    }
    return self;
}

- (void)resetConstraint
{
    [self setConstraint];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)setConstraint
{
    [self removeAllAutoLayout];
    
    if (self.topView)
    {
        if (self.mainLabel.text.length == 0 && self.subLabel.text.length == 0)
        {
            [self.topView addConstraint:NSLayoutAttributeCenterY equalTo:self offset:0];
        }
        else
        {
            [self.topView addConstraint:NSLayoutAttributeTop equalTo:self offset:PADDING];
        }
        [self.topView addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
        
    }
    
    if (self.mainLabel)
    {
        [self.mainLabel addConstraint:NSLayoutAttributeTop equalTo:self.topView fromConstraint:NSLayoutAttributeBottom offset:PADDING];
        [self.mainLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
        [self.mainLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
    }
    
    if (self.subLabel)
    {
        [self.subLabel addConstraint:NSLayoutAttributeTop equalTo:self.mainLabel fromConstraint:NSLayoutAttributeBottom offset:PADDING/2];
        [self.subLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING];
        [self.subLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING];
        
    }
    
    [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationGreaterThanOrEqual value:kVWCONTENTMINWIDTH];
    [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationLessThanOrEqual value:kVWCONTENTMAXWIDTH];
    [self addConstraint:NSLayoutAttributeHeight greatOrLess:NSLayoutRelationGreaterThanOrEqual value:kVWCONTENTMINWIDTH];
    
    UIView *lastView = self.topView;
    lastView = self.mainLabel.text.length>0?self.mainLabel:lastView;
    lastView = self.subLabel.text.length>0?self.subLabel:lastView;
    
    if (lastView != self.topView)
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:PADDING]];
    }

}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        [self addConstraint:NSLayoutAttributeCenterX equalTo:self.superview offset:0];
        [self addConstraint:NSLayoutAttributeCenterY equalTo:self.superview offset:0];


        [UIView animateWithDuration:0.25 animations:^{
            [self setAlpha:LOADINGALPHA];
        }];
        
        if (self.type == VWContentViewTypeMessage)
        {
            self.timer = [NSTimer timerWithTimeInterval:kVWMESDELAYTIME target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [self layoutIfNeeded];
        }
    }
}

@end
