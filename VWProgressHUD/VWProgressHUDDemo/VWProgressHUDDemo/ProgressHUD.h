//
//  ProgressHUD.h
//  VWProgressHUDDemo
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) SEL sel;
+ (instancetype)progressHUDWithName:(NSString *)name sel:(SEL)sel;
@end
