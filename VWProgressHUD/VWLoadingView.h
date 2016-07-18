//
//  VWLoadingView.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWLoadingView : UIView
- (instancetype)initWithTip:(NSString *)tip sub:(NSString *)sub;
- (void)setTip:(NSString *)tip sub:(NSString *)sub;
@end
