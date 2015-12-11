//
//  SMProgressHUDAlertView.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "SMProgressHUDAlertView.h"
#import "SMProgressHUDConfigure.h"
#import "SMProgressHUD.h"
#import "UIView+SMAutolayout.h"

static const NSInteger CANCELINDEX = 0;

@interface SMProgressHUDAlertView() <UITextFieldDelegate>
@property (strong, nonatomic) NSLayoutConstraint *centerY;
@end

@implementation SMProgressHUDAlertView

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                    delegate:(id/*<SMProgressHUDAlertViewDelegate>*/)delegate
              alertViewStyle:(SMProgressHUDAlertViewStyle)alertStyle
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (self = [super init])
    {
        [self.layer setCornerRadius:kSMProgressHUDCornerRadius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer  setShadowOffset:CGSizeMake(0, 2)];
        [self.layer setShadowOpacity:0.2];
        [self setAlpha:0];
        _delegate = delegate;
        
        //设置宽度
        [self addConstraint:NSLayoutAttributeWidth value:kSMProgressHUDAlertViewWidth];
        
        //标题
        UILabel *tipLabel = [UILabel new];
        [tipLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [tipLabel setText:title];
        [tipLabel setTextColor:[UIColor blackColor]];
        [self addSubview:tipLabel];
        [tipLabel addConstraint:NSLayoutAttributeTop equalTo:self offset:12];
        [tipLabel addConstraint:NSLayoutAttributeLeft equalTo:self offset:12];
        
        //分割线
        UIView *topLine = [UIView new];
        [topLine setBackgroundColor:SMGaryColor];
        [self addSubview:topLine];
        [topLine addConstraint:NSLayoutAttributeHeight value:0.5];
        [topLine addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
        [topLine addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
        [topLine addConstraint:NSLayoutAttributeTop equalTo:tipLabel fromConstraint:NSLayoutAttributeBottom offset:12];
        
        //信息
        UILabel *msgLabel = [UILabel new];
        [msgLabel setFont:[UIFont systemFontOfSize:15]];
        [msgLabel setNumberOfLines:0];
        [msgLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [msgLabel setText:message];
        [msgLabel setTextColor:SMTextColor];
        [msgLabel setPreferredMaxLayoutWidth:kSMProgressHUDAlertViewWidth-50];
        [self addSubview:msgLabel];
        
        [msgLabel addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
        [msgLabel addConstraint:NSLayoutAttributeTop equalTo:topLine offset:10];
        
        UIView *centerView = msgLabel;
        
        //是否有输入框
        switch (alertStyle)
        {
            case SMProgressHUDAlertViewStyleDefault:
            {
                break;
            }
            case SMProgressHUDAlertViewStylePlainTextInput:
            {
                UITextField *input = [UITextField new];
                [input.layer setCornerRadius:kSMProgressHUDCornerRadius];
                [input.layer setBorderColor:SMGaryColor.CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [self addSubview:input];
                
                [input addConstraint:NSLayoutAttributeTop equalTo:centerView fromConstraint:NSLayoutAttributeBottom offset:10];
                [input addConstraint:NSLayoutAttributeLeft equalTo:self offset:20];
                [input addConstraint:NSLayoutAttributeRight equalTo:self offset:-20];
                [input addConstraint:NSLayoutAttributeHeight value:40];
                
                centerView = input;
                _plainTextInput = input;
                
                break;
            }
            case SMProgressHUDAlertViewStyleSecureTextInput:
            {
                UITextField *input = [UITextField new];
                [input.layer setCornerRadius:kSMProgressHUDCornerRadius];
                [input.layer setBorderColor:SMGaryColor.CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [input setSecureTextEntry:YES];
                [self addSubview:input];
                
                [input addConstraint:NSLayoutAttributeTop equalTo:centerView fromConstraint:NSLayoutAttributeBottom offset:10];
                [input addConstraint:NSLayoutAttributeLeft equalTo:self offset:20];
                [input addConstraint:NSLayoutAttributeRight equalTo:self offset:-20];
                [input addConstraint:NSLayoutAttributeHeight value:40];
                centerView = input;
                _secureTextInput = input;
                break;
            }
            case SMProgressHUDAlertViewStyleLoginAndPasswordInput:
            {
                UITextField *input = [UITextField new];
                [input.layer setCornerRadius:kSMProgressHUDCornerRadius];
                [input.layer setBorderColor:SMGaryColor.CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [input setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addSubview:input];
                
                [input addConstraint:NSLayoutAttributeTop equalTo:centerView fromConstraint:NSLayoutAttributeBottom offset:10];
                [input addConstraint:NSLayoutAttributeLeft equalTo:self offset:20];
                [input addConstraint:NSLayoutAttributeRight equalTo:self offset:-20];
                [input addConstraint:NSLayoutAttributeHeight value:40];
                _plainTextInput = input;
                
                UITextField *secure = [UITextField new];
                [secure.layer setCornerRadius:kSMProgressHUDCornerRadius];
                [secure.layer setBorderColor:SMGaryColor.CGColor];
                [secure.layer setBorderWidth:0.5];
                [secure setDelegate:self];
                [secure setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [secure setLeftViewMode:UITextFieldViewModeAlways];
                [secure setFont:[UIFont systemFontOfSize:12]];
                [secure setClearButtonMode:UITextFieldViewModeAlways];
                [secure setSecureTextEntry:YES];
                [secure setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addSubview:secure];
                
                [secure addConstraint:NSLayoutAttributeTop equalTo:input fromConstraint:NSLayoutAttributeBottom offset:10];
                [secure addConstraint:NSLayoutAttributeLeft equalTo:self offset:20];
                [secure addConstraint:NSLayoutAttributeRight equalTo:self offset:-20];
                [secure addConstraint:NSLayoutAttributeHeight value:40];
                centerView = secure;
                
                _secureTextInput = secure;
                
            }
        }
        
        //底部线条
        UIView *bottonLine = [UIView new];
        [bottonLine setBackgroundColor:SMGaryColor];
        [self addSubview:bottonLine];
        
        [bottonLine addConstraint:NSLayoutAttributeHeight value:0.5];
        [bottonLine addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
        [bottonLine addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
        [bottonLine addConstraint:NSLayoutAttributeTop equalTo:centerView fromConstraint:NSLayoutAttributeBottom offset:12];
        
        NSMutableArray *buttonTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        [buttonTitles insertObject:cancelButtonTitle atIndex:0];
        
        //按钮
        UIButton *lastButton = nil;
        if (buttonTitles.count == 2)
        {
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [cancelButton addTarget:self action:@selector(alertViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTag:0];
            [self addSubview:cancelButton];
            
            [cancelButton addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
            [cancelButton addConstraint:NSLayoutAttributeTop equalTo:bottonLine fromConstraint:NSLayoutAttributeBottom offset:0];
            [cancelButton addConstraint:NSLayoutAttributeHeight value:44];
            [cancelButton addConstraint:NSLayoutAttributeWidth value:kSMProgressHUDAlertViewWidth/2];
            
            UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
            [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [otherButton setTranslatesAutoresizingMaskIntoConstraints:NO];
            [otherButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [otherButton addTarget:self action:@selector(alertViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [otherButton setTag:1];
            [self addSubview:otherButton];
            
            [otherButton addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
            [otherButton addConstraint:NSLayoutAttributeTop equalTo:bottonLine fromConstraint:NSLayoutAttributeBottom offset:0];
            [otherButton addConstraint:NSLayoutAttributeHeight value:44];
            [otherButton addConstraint:NSLayoutAttributeWidth value:kSMProgressHUDAlertViewWidth/2];
            lastButton = otherButton;
            
            UIView *centerLine = [UIView new];
            [centerLine setBackgroundColor:SMGaryColor];
            [self addSubview:centerLine];
            [centerLine addConstraint:NSLayoutAttributeWidth value:0.5];
            [centerLine addConstraint:NSLayoutAttributeHeight value:30];
            [centerLine addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
            [centerLine addConstraint:NSLayoutAttributeCenterY equalTo:cancelButton offset:0];
        }
        else
        {
            for (NSInteger index = 0; index < buttonTitles.count ; ++index)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
                [button setTitleColor:index==CANCELINDEX?[UIColor redColor]:[UIColor blackColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
                [button setTag:index];
                [button addTarget:self action:@selector(alertViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
                [self insertSubview:button atIndex:0];
                
                if (lastButton)
                {
                    [button addConstraint:NSLayoutAttributeTop equalTo:lastButton fromConstraint:NSLayoutAttributeBottom offset:0];
                }
                else
                {
                    [button addConstraint:NSLayoutAttributeTop equalTo:bottonLine fromConstraint:NSLayoutAttributeBottom offset:0];
                }
                [button addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
                [button addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
                [button addConstraint:NSLayoutAttributeHeight value:44];
                
                if (index < buttonTitles.count-1)
                {
                    UIView *line = [UIView new];
                    [line setBackgroundColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]];
                    [self addSubview:line];
                    
                    [line addConstraint:NSLayoutAttributeLeft equalTo:self offset:5];
                    [line addConstraint:NSLayoutAttributeRight equalTo:self offset:-5];
                    [line addConstraint:NSLayoutAttributeHeight value:0.5];
                    [line addConstraint:NSLayoutAttributeTop equalTo:button fromConstraint:NSLayoutAttributeBottom offset:0];
                }
                lastButton = button;
            }
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

#pragma mark 点击事件
- (void)alertViewDidClickedButtonAtIndex:(UIButton *)senger
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [_delegate alertView:self clickedButtonAtIndex:senger.tag];
        }
        if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:userInfo:)])
        {
            [_delegate alertView:self clickedButtonAtIndex:senger.tag userInfo:_userInfo];
        }
    }
    
    [[SMProgressHUD shareInstancetype] dismissAlertView];
}

#pragma mark 键盘开启
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _centerY.constant = -kSMProgressWindowHeight/4;
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark 键盘关闭
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _centerY.constant = 0;
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [self layoutIfNeeded];
    }];
    
}

#pragma mark 设置位置
- (void)didMoveToSuperview
{
    if (self.superview)
    {
        _centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.superview addConstraint:_centerY];
        [self addConstraint:NSLayoutAttributeCenterX equalTo:self.superview offset:0];
    }
}
@end
