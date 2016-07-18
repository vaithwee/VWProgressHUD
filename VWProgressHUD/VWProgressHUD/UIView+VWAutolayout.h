//
//  UIView+VWAutolayout.h
//  VWProgressHUD
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VWAutolayout)
- (void)addConstraint:(NSLayoutAttribute)attribute value:(CGFloat)value;
- (void)addConstraint:(NSLayoutAttribute)attribute greatOrLess:(NSLayoutRelation)rela value:(CGFloat)value;
- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset;
- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to multiplier:(CGFloat)multiplier;
- (void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to fromConstraint:(NSLayoutAttribute)fromAttribute offset:(CGFloat)offset;
- (void)removeAutoLayout:(NSLayoutConstraint *)constraint;
- (void)removeAllAutoLayout;
@end
