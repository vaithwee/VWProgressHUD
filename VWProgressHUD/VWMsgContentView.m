//
//  VWMsgContentView.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/19.
//  Copyright © 2016年 Vaith. All rights reserved.
//


#import "UIView+VWAutolayout.h"
#import "VWMsgContentView.h"
#import "VWConfig.h"

@interface VWMsgContentView()
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *msgLabel;
@end

@implementation VWMsgContentView

- (instancetype)initWithMsg:(NSString *)msg type:(VWMsgType)type
{
    if (self = [super init])
    {
        /*default setting*/
        [self setBackgroundColor:HEXCOLOR(DMINANTCOLOR)];
        [self setAlpha:0];
        [self.layer setCornerRadius:5.f];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowOpacity:0.2f];


        NSString *pathString = @"";
        switch (type)
        {
            case VWMsgTypeDone:
            {
                pathString = @"VWProgressHUD.bundle/done";
                break;
            }
            case VWMsgTypeFail:
            {
                pathString = @"VWProgressHUD.bundle/fail";
                break;
            }
            case VWMsgTypeWarning:
            {
                pathString = @"VWProgressHUD.bundle/warning";
                break;
            }
            case VWMsgTypeDefault:
            {
                pathString = @"VWProgressHUD.bundle/done";
                break;
            }
        }
        UIImageView *iconImageView = [UIImageView new];
        [iconImageView setImage:[UIImage imageNamed:pathString]];
        [self addSubview:iconImageView];
        self.iconImageView = iconImageView;

        UILabel *msgLabel = [UILabel new];
        [msgLabel setText:msg];
        [msgLabel setFont:[UIFont systemFontOfSize:DEFAULTTIPFONT]];
        [msgLabel setTextColor:HEXCOLOR(TEXTCOLOR)];
        [msgLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [msgLabel setNumberOfLines:0];
        [msgLabel setTextAlignment:NSTextAlignmentCenter];
        [msgLabel setPreferredMaxLayoutWidth:kVWCONTENTMAXWIDTH-PADDING];
        [self addSubview:msgLabel];
        self.msgLabel = msgLabel;

        [self setConstraint];
    }
    return self;
}


- (void)setConstraint
{
    [self removeAllAutoLayout];

    [self.iconImageView addConstraint:NSLayoutAttributeTop equalTo:self offset:PADDING];
    [self.iconImageView addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];

    [self.msgLabel addConstraint:NSLayoutAttributeTop equalTo:self.iconImageView fromConstraint:NSLayoutAttributeBottom offset:PADDING/2];
    [self.msgLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:PADDING/2];
    [self.msgLabel addConstraint:NSLayoutAttributeRight equalTo:self offset:-PADDING/2];

    [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationGreaterThanOrEqual value:kVWCONTENTMINWIDTH];
    [self addConstraint:NSLayoutAttributeWidth greatOrLess:NSLayoutRelationLessThanOrEqual value:kVWCONTENTMAXWIDTH];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.msgLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:PADDING]];
    [self layoutIfNeeded];
}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        [self addConstraint:NSLayoutAttributeCenterX equalTo:self.superview offset:0];
        [self addConstraint:NSLayoutAttributeCenterY equalTo:self.superview offset:0];
    }
}

- (void)setMsg:(NSString *)msg type:(VWMsgType)type
{
    NSString *pathString = @"";
    switch (type)
    {
        case VWMsgTypeDone:
        {
            pathString = @"VWProgressHUD.bundle/done";
            break;
        }
        case VWMsgTypeFail:
        {
            pathString = @"VWProgressHUD.bundle/fail";
            break;
        }
        case VWMsgTypeWarning:
        {
            pathString = @"VWProgressHUD.bundle/warning";
            break;
        }
        case VWMsgTypeDefault:
        {
            pathString = @"VWProgressHUD.bundle/done";
            break;
        }
    }
    [self.iconImageView setImage:[UIImage imageNamed:pathString]];
    [self.msgLabel setText:msg];
    [self setConstraint];
}
@end
