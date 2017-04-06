//
//  VWBaseContentView+VWLoading.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "VWBaseContentView+VWLoading.h"
#import "VWConfig.h"

@implementation VWBaseContentView (VWLoading)
- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
{
    if (self = [self init])
    {
        
        [self setType:VWContentViewTypeLoading];
        
        /*创建loading*/
        UIView *loadingView = [self loadingView];
        [self addSubview:loadingView];
        self.topView = loadingView;
        
        if (isShowkVWDefaultLoadingTip && (!tip || [tip isEqualToString:@""]))
        {
            tip = kVWDefaultLoadingTip;
        }
        
        [self.mainLabel setText:tip];
        [self.subLabel setText:sub];
        [self setConstraint];
        
        self.timer = [NSTimer timerWithTimeInterval:kVWLoadingDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

- (void)setTip:(NSString *)tip sub:(NSString *)sub;
{
    [self.mainLabel setText:tip];
    [self.subLabel setText:sub];
    [self resetConstraint];
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:kVWLoadingDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)toBeLoadingWithTip:(NSString *)tip sub:(NSString *)sub
{
    if (VWContentViewTypeLoading != self.type)
    {
        [self setType:VWContentViewTypeLoading];
        
        [self.topView removeFromSuperview];
        
        /*创建loading*/
        UIView *loadingView = [self loadingView];
        [self addSubview:loadingView];
        
        self.topView = loadingView;
        [self.mainLabel setText:tip];
        [self.subLabel setText:sub];
        [self setConstraint];
        [self.topView layoutIfNeeded];
        [UIView animateWithDuration:kVWDefaultAnimationTime animations:^{
            [self layoutIfNeeded];
        }];
        
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:kVWLoadingDelayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}

- (NSArray *)loadImages
{
    
    NSArray *images = [VWProgressHUD shareInstance].loadingAnimationImages;
    NSMutableArray *imagesM = [[NSMutableArray alloc] init];
    for (int i = 1; i < images.count; i++)
    {
        NSString *imageName = [NSString stringWithFormat:images[i]];
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesM addObject:image];
    }
    return imagesM;
}

- (UIView *)loadingView
{
    if ([VWProgressHUD shareInstance].loadingAnimationImages.count > 0)
    {
        UIImageView *aniImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [aniImageView setAnimationImages:[self loadImages]];
        [aniImageView setAnimationDuration:1];
        [aniImageView setAnimationRepeatCount:99999];
        [aniImageView startAnimating];
        return aniImageView;
    }
    else
    {
        UIActivityIndicatorView *loadingView = [UIActivityIndicatorView new];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loadingView setColor:VWHEXCOLOR(kVWLoadingColor)];
        [loadingView setHidesWhenStopped:YES];
        [loadingView startAnimating];
        return loadingView;
    }
    
}
@end
