//
//  UIView+VWAutolayout.m
//  VWProgressHUD
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "UIView+VWAutolayout.h"

@implementation UIView (VWAutolayout)
-(void)addConstraint:(NSLayoutAttribute)attribute value:(CGFloat)value
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:value]];
}

- (void)addConstraint:(NSLayoutAttribute)attribute greatOrLess:(NSLayoutRelation)rela value:(CGFloat)value
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:rela toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:value]];
}

-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:attribute multiplier:1.0 constant:offset]];
}

-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to multiplier:(CGFloat)multiplier
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:attribute multiplier:multiplier constant:0]];
}

-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to fromConstraint:(NSLayoutAttribute)fromAttribute offset:(CGFloat)offset
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:fromAttribute multiplier:1.0 constant:offset]];
}

- (void)removeAutoLayout:(NSLayoutConstraint *)constraint
{
    for (NSLayoutConstraint *con in self.superview.constraints) {
        if ([con isEqual:constraint]) {
            [self.superview removeConstraint:con];
        }
    }
}

- (void)removeAllAutoLayout
{
    for (NSLayoutConstraint *con in self.constraints)
    {
        [self removeConstraint:con];
    }
}
@end
