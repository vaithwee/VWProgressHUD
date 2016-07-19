//
//  VWBaseContentView.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/19.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VWContentViewType)
{
    VWContentViewTypeLoading,
    VWContentViewTypeMessage
};

@interface VWBaseContentView : UIView
@property (assign, nonatomic) VWContentViewType type;
@property (weak, nonatomic) UIView *topView;
@property (weak, nonatomic) UILabel *mainLabel;
@property (weak, nonatomic) UILabel *subLabel;
- (void)setConstraint;
- (void)resetConstraint;
@end
