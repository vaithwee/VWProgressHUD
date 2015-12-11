//
//  UIView+SMAutolayout.h
//  SMProgressHUD
//
//  Created by Vaith on 15/12/9.
//  Copyright © 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SMAutolayout)
-(void)addConstraint:(NSLayoutAttribute)attribute value:(CGFloat)value;
-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset;
-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to multiplier:(CGFloat)multiplier;
-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to fromConstraint:(NSLayoutAttribute)fromAttribute offset:(CGFloat)offset;
- (void)removeAutoLayout:(NSLayoutConstraint *)constraint;
- (void)removeAllAutoLayout;
@end
