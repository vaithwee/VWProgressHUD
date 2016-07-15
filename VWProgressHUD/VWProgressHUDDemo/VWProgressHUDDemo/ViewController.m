//
//  ViewController.m
//  VWProgressHUDDemo
//
//  Created by Vaith on 16/7/15.
//  Copyright (c) 2016 Shenme Studio. All rights reserved.
//


#import "ViewController.h"
#import <VWProgressHUD/VWProgressHUD.h>


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    UITextField  *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    [textField setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:textField];

    UIButton *show = [UIButton buttonWithType:UIButtonTypeCustom];
    [show setBackgroundColor:[UIColor redColor]];
    [show setFrame:CGRectMake(0,120,100,100)];
    [show setTitle:@"show" forState:UIControlStateNormal];
    [show addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:show];


}

- (void)show
{
    [[VWProgressHUD shareInstance] showLoading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end