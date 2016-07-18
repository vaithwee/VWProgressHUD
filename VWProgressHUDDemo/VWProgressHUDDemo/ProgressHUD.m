//
//  ProgressHUD.m
//  VWProgressHUDDemo
//
//  Created by Vaith on 16/7/18.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD
+ (instancetype)progressHUDWithName:(NSString *)name sel:(SEL)sel
{
    return [[self alloc] initProgressHUDWithName:name sel:sel];
}

- (instancetype)initProgressHUDWithName:(NSString *)name sel:(SEL)sel
{
    if (self = [super init])
    {
        self.name = name;
        self.sel = sel;
    }
    return self;
    
}
@end
