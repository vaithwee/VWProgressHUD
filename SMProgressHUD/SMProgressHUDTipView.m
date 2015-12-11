//
//  SMProgressHUDTipView.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "SMProgressHUDTipView.h"
#import "SMProgressHUDConfigure.h"
#import "SMProgressHUD.h"
#import "UIView+SMAutolayout.h"

@implementation SMProgressHUDTipView
- (instancetype)initWithTip:(NSString *)tip tipType:(SMProgressHUDTipType)type
{
    if (self = [super init])
    {
        [self.layer setCornerRadius:kSMProgressHUDCornerRadius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setShadowOffset:CGSizeMake(2, 2)];
        [self.layer setShadowOpacity:0.2];
        [self setAlpha:0];
        [self.layer setBorderWidth:.2f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        [icon addConstraint:NSLayoutAttributeWidth value:35];
        [icon addConstraint:NSLayoutAttributeHeight value:35];
        [icon addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
        [icon addConstraint:NSLayoutAttributeTop equalTo:self offset:10];
       
        switch (type)
        {
            case SMProgressHUDTipTypeSucceed:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/succeed"]];
                break;
            case SMProgressHUDTipTypeDone:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/done"]];
                break;
            case SMProgressHUDTipTypeError:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/error"]];
                break;
            case SMProgressHUDTipTypeWarning:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/warning"]];
                break;
        }
        
        UILabel *message = [UILabel new];
        [message setTextColor:[UIColor grayColor]];
        [message setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [message setNumberOfLines:0];
        [message setLineBreakMode:NSLineBreakByCharWrapping];
        [message setTextAlignment:NSTextAlignmentLeft];
        [message setText:tip];
        [message setPreferredMaxLayoutWidth:kSMProgressHUDContentWidth-20];
        [self addSubview:message];
        
        [message addConstraint:NSLayoutAttributeTop equalTo:icon fromConstraint:NSLayoutAttributeBottom offset:10];
        [message addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
        [message layoutIfNeeded];
        
        CGFloat width = message.frame.size.width>60?message.frame.size.width+20:60.f+20;
        [self addConstraint:NSLayoutAttributeWidth value:width];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:message attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    }
    return self;
}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        [self layoutIfNeeded];
    }
}
@end
