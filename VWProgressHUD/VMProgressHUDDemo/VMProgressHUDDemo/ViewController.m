//
//  ViewController.m
//  VMProgressHUDDemo
//
//  Created by Vaith on 16/7/15.
//  Copyright © 2016年 Vaith. All rights reserved.
//

#import "ViewController.h"
#import <VWProgressHUD/VWProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [VWProgressHUD log];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
