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
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation VWMsgContentView

- (instancetype)initWithMsg:(NSString *)msg type:(VWMsgType)type
{
    if (self = [super init])
    {
        [self setType:VWContentViewTypeMessage];

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
        self.topView = iconImageView;

        [self.mainLabel setText:msg];

        [self setConstraint];
    }
    return self;
}



#pragma mark dismiss
- (void)dismiss
{
    __weak VWMsgContentView *weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakself setAlpha:0];
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
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
    [(UIImageView *)self.topView setImage:[UIImage imageNamed:pathString]];
    [self.mainLabel setText:msg];
    [self setConstraint];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:kVWMESDELAYTIME target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}
@end
