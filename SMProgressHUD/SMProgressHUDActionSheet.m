//
//  SMProgressHUDActionSheet.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/12/10.
//  Copyright © 2015年 Shenme Studio. All rights reserved.
//

#import "SMProgressHUDActionSheet.h"
#import "UIView+SMAutolayout.h"
#import "SMProgressHUDConfigure.h"
#import "SMProgressHUD.h"

@interface SMProgressHUDActionSheet()
@property (weak, nonatomic) id<SMProgressHUDActionSheetDelegate> delegate;
@property (strong, nonatomic) NSLayoutConstraint *centerY;
@property (strong, nonatomic) NSDictionary *userInfo;
@end

@implementation SMProgressHUDActionSheet
- (instancetype)initWithTitle:(NSString *)title delegate:(id<SMProgressHUDActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles userInfo:(NSDictionary *)userinfo
{
    if (self = [super init])
    {
        [self setAlpha:0.93];
        [self addConstraint:NSLayoutAttributeWidth value:kSMProgressWindowWidth];
        [self setBackgroundColor:[UIColor colorWithRed:230/255.f green:230/255.f  blue:230/255.f  alpha:1]];
        [self.layer setCornerRadius:kSMProgressHUDCornerRadius];
        [self setClipsToBounds:YES];
        _delegate = delegate;
        
        UIView *lastView = nil;
        if (title.length > 0)
        {
            UILabel *titleLabel = [UILabel new];
            [titleLabel setTextColor:SMTextColor];
            [titleLabel setText:title];
            [titleLabel setNumberOfLines:0];
            [titleLabel setFont:[UIFont systemFontOfSize:12]];
            [titleLabel setBackgroundColor:[UIColor whiteColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setPreferredMaxLayoutWidth:kSMProgressWindowWidth-40];
            [self addSubview:titleLabel];
            
            [titleLabel addConstraint:NSLayoutAttributeTop equalTo:self offset:12];
            [titleLabel addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
            [titleLabel addConstraint:NSLayoutAttributeWidth value:kSMProgressWindowWidth-40];
            
            UIView *labelBackView = [UIView new];
            [labelBackView setBackgroundColor:[UIColor whiteColor]];
            [self insertSubview:labelBackView atIndex:0];
            
            [labelBackView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
            [labelBackView addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
            [labelBackView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
            [labelBackView addConstraint:NSLayoutAttributeBottom equalTo:titleLabel offset:12];
            lastView = titleLabel;
        }
        
        UIButton *destructiveButton = nil;
        if (destructiveButtonTitle)
        {
            destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
            [destructiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [destructiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [destructiveButton setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:destructiveButton];
            
            if (lastView)
            {
                [destructiveButton addConstraint:NSLayoutAttributeTop equalTo:lastView fromConstraint:NSLayoutAttributeBottom offset:12.5];
            }
            else
            {
                [destructiveButton addConstraint:NSLayoutAttributeTop equalTo:self fromConstraint:NSLayoutAttributeTop offset:0];
            }
            
            [destructiveButton addConstraint:NSLayoutAttributeWidth value:kSMProgressWindowWidth];
            [destructiveButton addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
            [destructiveButton addConstraint:NSLayoutAttributeHeight value:44];
            [destructiveButton setTag:1];
            [destructiveButton addTarget:self action:@selector(actionSheetViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            lastView = destructiveButton;
            
        }
        
        
        for (NSInteger index = 0; index < otherButtonTitles.count; ++index)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:otherButtonTitles[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(actionSheetViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:destructiveButtonTitle?index+2:index+1];
            [self addSubview:button];
            
            if (lastView)
            {
                if ([lastView isKindOfClass:[UILabel class]])
                {
                    [button addConstraint:NSLayoutAttributeTop equalTo:lastView fromConstraint:NSLayoutAttributeBottom offset:12.5];
                }
                else
                {
                    [button addConstraint:NSLayoutAttributeTop equalTo:lastView fromConstraint:NSLayoutAttributeBottom offset:0.5];
                }
                
            }
            else
            {
                [button addConstraint:NSLayoutAttributeTop equalTo:self fromConstraint:NSLayoutAttributeBottom offset:0];
            }
            
            [button addConstraint:NSLayoutAttributeWidth value:kSMProgressWindowWidth];
            [button addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
            [button addConstraint:NSLayoutAttributeHeight value:44];
            lastView = button;
        }
        
        if (cancelButtonTitle.length > 0)
        {
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [cancelButton setBackgroundColor:[UIColor whiteColor]];
            [cancelButton addTarget:self action:@selector(actionSheetViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTag:0];
            [self addSubview:cancelButton];
            
            if (lastView)
            {
                [cancelButton addConstraint:NSLayoutAttributeTop equalTo:lastView fromConstraint:NSLayoutAttributeBottom offset:10];
            }
            else
            {
                [cancelButton addConstraint:NSLayoutAttributeTop equalTo:self fromConstraint:NSLayoutAttributeBottom offset:0];
            }
            
            [cancelButton addConstraint:NSLayoutAttributeWidth value:kSMProgressWindowWidth];
            [cancelButton addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
            [cancelButton addConstraint:NSLayoutAttributeHeight value:44];
            lastView = cancelButton;
            
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

- (void)actionSheetViewDidClickedButtonAtIndex:(UIButton *)senger
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(actionSheetView:clickedButtonAtIndex:)])
        {
            [self.delegate actionSheetView:self clickedButtonAtIndex:senger.tag];
        }
        else if ([self.delegate respondsToSelector:@selector(actionSheetView:clickedButtonAtIndex:userInfo:)])
        {
            [self.delegate actionSheetView:self clickedButtonAtIndex:senger.tag userInfo:_userInfo];
        }
    }
    [[SMProgressHUD shareInstancetype] dismissActionSheet];
}

#pragma 显示
- (void)show
{
    _centerY.constant = -self.frame.size.height;
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
           _centerY.constant = -self.frame.size.height;
    }];
}

- (void)hide
{
    _centerY.constant = 0;
}

- (void)remove
{
    _centerY.constant = 0;
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        [self addConstraint:NSLayoutAttributeCenterX equalTo:self.superview offset:0];
        _centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.superview addConstraint:_centerY];
        [self layoutIfNeeded];
    }
}

@end
