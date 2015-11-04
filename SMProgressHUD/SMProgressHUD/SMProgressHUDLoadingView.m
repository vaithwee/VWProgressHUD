//
//  SMProgressHUDLoadingView.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/10.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "SMProgressHUDLoadingView.h"
#import "SMProgressHUDConfigure.h"

@interface SMProgressHUDLoadingView()
@property (weak, nonatomic) UILabel *tip;
@property (strong, nonatomic) NSMutableArray *circles;
@end

@implementation SMProgressHUDLoadingView

#pragma mark 创建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _circles = [NSMutableArray array];
        [self.layer setCornerRadius:kSMProgressHUDCornerRadius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setShadowOffset:CGSizeMake(0, 2)];
        [self.layer setShadowOpacity:0.2];
        
        //提示语
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.6, frame.size.width, frame.size.height*0.3)];
        [tip setText:SMProgressHUDLoadingTip];
        [tip setTextColor:[UIColor grayColor]];
        [tip setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [tip setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:tip];
        self.tip = tip;
    }
    return self;
}

#pragma mark 添加动画
- (void)addAnimation
{
    CGFloat width = 10.f;
    CGFloat x = (self.frame.size.width - width*6 -50)/2;
    CGFloat y = 30.f;
    for (NSInteger index = 0; index < 6; ++index)
    {
        CALayer *cirlce = [CALayer layer];
        [cirlce setFrame:CGRectMake(x + (width+10)*index, y, width, width)];
        [cirlce setBackgroundColor:[UIColor colorWithRed:0.1+0.2*index green:0.1+0.1*index blue:0.1+0.1*index alpha:1].CGColor];
        [cirlce setCornerRadius:width/2];
        [self.layer addSublayer:cirlce];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [anim setFromValue:@0];
        [anim setToValue:@1];
        [anim setAutoreverses:YES];
        [anim setDuration:0.8];
        [anim setRemovedOnCompletion:YES];
        [anim setBeginTime:CACurrentMediaTime()+0.2*index-1];
        [anim setRepeatCount:INFINITY];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [cirlce addAnimation:anim forKey:nil];
        [_circles addObject:cirlce];
    }
}

#pragma mark 重置提示语
- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    if (alpha == 0)
    {
        [_tip setText:SMProgressHUDLoadingTip];
    }
}

#pragma mark 开始动画
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (_circles.count == 0)
    {
        [self addAnimation];
    }
}

#pragma mark 停止动画
- (void)removeFromSuperview
{
    [super removeFromSuperview];
    for (CALayer *circle in _circles)
    {
        [circle removeFromSuperlayer];
    }
    [_circles removeAllObjects];
}

#pragma mark 设置提示文字
-(void)setTipText:(NSString *)tip;
{
    [_tip setText:tip==nil?SMProgressHUDLoadingTip:tip];
}
@end
