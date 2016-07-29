//
// Created by Vaith on 16/7/15.
// Copyright (c) 2016 Vaith. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

extern NSInteger const kVWDminantColor;
extern NSInteger const kVWLoadingColor;
extern NSInteger const kVWTextColor;
extern NSInteger const kVWImageColor;


extern CGFloat const LOADINGALPHA;
extern CGFloat const PADDING;
extern CGFloat const MAXTEXTWIDTH;
extern CGFloat const DEFAULTTIPFONT;
extern CGFloat const DEFAULTSUBFONT;
extern CGFloat const DELAYTIME;
extern CGFloat const kVWCONTENTMINWIDTH;
extern CGFloat const kVWCONTENTMAXWIDTH;
extern CGFloat const kVWMESDELAYTIME;



extern BOOL const ISSHOWDEFAULTTIP;

extern NSString const * DEFAULTTIP;

@interface VWConfig : NSObject
@end