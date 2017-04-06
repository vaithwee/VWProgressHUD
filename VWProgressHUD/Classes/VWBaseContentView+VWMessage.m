//
//  VWBaseContentView+VWMessage.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWBaseContentView+VWMessage.h"

@implementation VWBaseContentView (VWMessage)
- (instancetype)initWithMsg:(NSString *)msg type:(VWMsgType)type
{
    if (self = [self init])
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

        [iconImageView setImage:[[self imageNamed:pathString] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [iconImageView setTintColor:VWHEXCOLOR(kVWImageColor)];
        [self addSubview:iconImageView];
        self.topView = iconImageView;
        
        [self.mainLabel setText:msg];
        
        [self setConstraint];
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:kVWMessageDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (UIImage *)imageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    if (!image)
    {
        image = [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    return image;
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
    [(UIImageView *)self.topView setImage:[[self imageNamed:pathString] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.mainLabel setText:msg];
    [self setConstraint];
    
    [UIView animateWithDuration:kVWDefaultAnimationTime animations:^{
        [self layoutIfNeeded];
    }];
    
    
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:kVWMessageDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}

- (void)toBeMessageWithMsg:(NSString *)msg type:(VWMsgType)type
{
    if (VWContentViewTypeMessage != self.type)
    {
        [self.topView removeFromSuperview];
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
        [iconImageView setImage:[[self imageNamed:pathString] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [iconImageView setTintColor:VWHEXCOLOR(kVWImageColor)];
        [self addSubview:iconImageView];
        self.topView = iconImageView;
        [self.mainLabel setText:msg];
        [self.subLabel setText:nil];
        [self setConstraint];
        
        [self.topView layoutIfNeeded];
        [UIView animateWithDuration:kVWDefaultAnimationTime animations:^{
            [self layoutIfNeeded];
        }];
        
        
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:kVWMessageDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
    }
}
@end
