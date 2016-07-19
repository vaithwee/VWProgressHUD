//
//  VWLoadingView.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VWBaseContentView.h"

@interface VWLoadingView : VWBaseContentView
- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
- (void)setTip:(NSString *)tip sub:(NSString *)sub;
@end
