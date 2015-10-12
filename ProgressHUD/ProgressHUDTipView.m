//
//  ProgressHUDTipView.m
//  ProgressHUD
//
//  Created by OrangeLife on 15/10/12.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "ProgressHUDTipView.h"
#import "ProgressHUDConfigure.h"
#import "ProgressHUD.h"

@implementation ProgressHUDTipView
- (instancetype)initWithTip:(NSString *)tip tipType:(ProgressHUDTipType)type
{
    if (self = [super init])
    {
        [self.layer setCornerRadius:kProgressHUDCornerRadius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setShadowOffset:CGSizeMake(2, 2)];
        [self.layer setShadowOpacity:0.2];
        [self setAlpha:0];
        [self.layer setBorderWidth:.2f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [icon setFrame:CGRectMake(0, 0, 30, 30)];
        [self addSubview:icon];
        
        switch (type)
        {
            case ProgressHUDTipTypeSucceed:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/succeed"]];
                break;
            case ProgressHUDTipTypeDone:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/done"]];
                break;
            case ProgressHUDTipTypeError:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/error"]];
                break;
            case ProgressHUDTipTypeWarning:
                [icon setImage:[UIImage imageNamed:@"progresshud.bundle/warning"]];
                break;
        }
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+5, kProgressHUDContentWidth-20, MAXFLOAT)];
        [message setTextColor:[UIColor grayColor]];
        [message setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [message setNumberOfLines:0];
        [message setLineBreakMode:NSLineBreakByCharWrapping];
        [message setTextAlignment:NSTextAlignmentLeft];
        [message setText:tip];
        [message sizeToFit];
        [self addSubview:message];
        
        CGFloat width = message.frame.size.width>60?message.frame.size.width+20:60.f+20;
        CGFloat height = message.frame.size.height + icon.frame.size.height + 25.f;
        [self setFrame:CGRectMake(0, 0, width, height)];
        [self setCenter:CGPointMake(kProgressWindowWidth/2, kProgressWindowHeight/2)];
        [icon setCenter:CGPointMake(width/2, icon.frame.size.height/2+10)];
        [message setCenter:CGPointMake(width/2, CGRectGetMaxY(icon.frame)+5+message.frame.size.height/2)];
    }
    return self;
}
@end
