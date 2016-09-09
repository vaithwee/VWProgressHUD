//
// Created by Vaith on 16/7/15.
// Copyright (c) 2016 Vaith. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VWHEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

extern NSInteger const kVWDminantColor;
extern NSInteger const kVWLoadingColor;
extern NSInteger const kVWTextColor;
extern NSInteger const kVWImageColor;


extern CGFloat const kVWDefaultAlpha;
extern CGFloat const kVWPadding;
extern CGFloat const kVWMaxTextWidth;
extern CGFloat const kVWDefaultTipFontSize;
extern CGFloat const kVWDefaultSubFontSize;
extern CGFloat const kVWLoadingDelayTime;
extern CGFloat const kVWMessageDelayTime;

extern CGFloat const kVWContentMinWidth;
extern CGFloat const kVWContentMaxWidth;

extern CGFloat const kVWDefaultAnimationTime;




extern BOOL const isShowkVWDefaultLoadingTip;

extern NSString * const kVWDefaultLoadingTip;
extern NSString * const kVWDismissNotification;

@interface VWConfig : NSObject
@end