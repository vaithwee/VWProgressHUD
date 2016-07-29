//
//  VWBaseContentView+VWLoading.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/29.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <VWProgressHUD/VWProgressHUD.h>
#import "VWEnum.h"

@interface VWBaseContentView (VWLoading)
- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
- (void)setTip:(NSString *)tip sub:(NSString *)sub;
- (void)toBeLoadingWithTip:(NSString *)tip sub:(NSString *)sub;
@end
