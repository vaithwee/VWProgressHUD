//
//  ProgressHUDAlertView.m
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "ProgressHUDAlertView.h"
#import "ProgressHUDConfigure.h"
#import "ProgressHUD.h"
#import <objc/runtime.h>

static const NSInteger CANCELINDEX = 0;

@interface ProgressHUDAlertView() <UITextFieldDelegate>
@end

@implementation ProgressHUDAlertView
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id/*<ProgressHUDAlertViewDelegate>*/)delegate alertViewStyle:(ProgressHUDAlertViewStyle)alertStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    CGRect frame = CGRectMake(0, 0, kProgressHUDAlertViewWidth, 20);
    if (self = [super initWithFrame:frame])
    {
        [self.layer setCornerRadius:kProgressHUDCornerRadius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer  setShadowOffset:CGSizeMake(0, 2)];
        [self.layer setShadowOpacity:0.2];
        [self.layer setMasksToBounds:YES];
        [self setAlpha:0];
        _delegate = delegate;
        
        CGFloat x = 0;
        CGFloat y = 10.f;
        CGFloat width = frame.size.width;
        CGFloat height = 20.f;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [tipLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [tipLabel setText:title];
        [tipLabel setTextColor:[UIColor grayColor]];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:tipLabel];
        
        x = 20.f;
        y = CGRectGetMaxY(tipLabel.frame)+5;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y,width-2*x, 1)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:line];
        
        y = CGRectGetMaxY(line.frame)+10;
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, frame.size.width-2*x, MAXFLOAT)];
        [msgLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [msgLabel setNumberOfLines:0];
        [msgLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [msgLabel setText:message];
        [msgLabel setTextColor:[UIColor grayColor]];
        [msgLabel sizeToFit];
        [msgLabel setCenter:CGPointMake(kProgressHUDAlertViewWidth/2, y+msgLabel.frame.size.height/2)];
        [self addSubview:msgLabel];
        
        y = CGRectGetMaxY(msgLabel.frame)+10;
        switch (alertStyle)
        {
            case ProgressHUDAlertViewStyleDefault:
            {
                break;
            }
            case ProgressHUDAlertViewStylePlainTextInput:
            {
                UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(x, y, frame.size.width-2*x, 35)];
                [input.layer setCornerRadius:kProgressHUDCornerRadius];
                [input.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [self addSubview:input];
                _plainTextInput = input;
                y = CGRectGetMaxY(input.frame)+10.f;
                break;
            }
            case ProgressHUDAlertViewStyleSecureTextInput:
            {
                UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(x, y, frame.size.width-2*x, 35)];
                [input.layer setCornerRadius:kProgressHUDCornerRadius];
                [input.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [input setSecureTextEntry:YES];
                [self addSubview:input];
                _secureTextInput = input;
                y = CGRectGetMaxY(input.frame)+10.f;
                break;
            }
            case ProgressHUDAlertViewStyleLoginAndPasswordInput:
            {
                UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(x, y, frame.size.width-2*x, 35)];
                [input.layer setCornerRadius:kProgressHUDCornerRadius];
                [input.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [input.layer setBorderWidth:0.5];
                [input setDelegate:self];
                [input setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [input setLeftViewMode:UITextFieldViewModeAlways];
                [input setFont:[UIFont systemFontOfSize:12]];
                [input setClearButtonMode:UITextFieldViewModeAlways];
                [self addSubview:input];
                _plainTextInput = input;
                
                y = CGRectGetMaxY(input.frame)-0.5f;
                UITextField *secure = [[UITextField alloc] initWithFrame:CGRectMake(x, y, frame.size.width-2*x, 35)];
                [secure.layer setCornerRadius:kProgressHUDCornerRadius];
                [secure.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [secure.layer setBorderWidth:0.5];
                [secure setDelegate:self];
                [secure setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
                [secure setLeftViewMode:UITextFieldViewModeAlways];
                [secure setFont:[UIFont systemFontOfSize:12]];
                [secure setClearButtonMode:UITextFieldViewModeAlways];
                [secure setSecureTextEntry:YES];
                _secureTextInput = secure;
                
                 y = CGRectGetMaxY(secure.frame)+10.f;
            }
        }
        
        NSMutableArray *buttonTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        [buttonTitles insertObject:cancelButtonTitle atIndex:0];
        
        width = kProgressHUDAlertViewWidth/buttonTitles.count;
        for (NSInteger index = 0; index < buttonTitles.count ; ++index)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(width*index, y , width, 35)];
            
            [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
            [button setTitleColor:index==CANCELINDEX?[UIColor redColor]:[UIColor grayColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [button setTag:index];
            [button addTarget:self action:@selector(alertViewDidClickedButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        y = y + 35;
        
        
        [self setFrame:CGRectMake(0, 0, kProgressHUDAlertViewWidth, y)];
        [self setCenter:CGPointMake(kProgressWindowWidth/2, kProgressWindowHeight/2)];
        
    }
    return self;
}

- (void)alertViewDidClickedButtonAtIndex:(UIButton *)senger
{
    if (_delegate)
    {
        [_delegate alertView:self clickedButtonAtIndex:senger.tag];
    }
    
    [[ProgressHUD shareInstancetype] alertViewDismiss];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setCenter:CGPointMake(kProgressWindowWidth/2, kProgressWindowHeight/4)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setCenter:CGPointMake(kProgressWindowWidth/2, kProgressWindowHeight/2)];
}
@end
