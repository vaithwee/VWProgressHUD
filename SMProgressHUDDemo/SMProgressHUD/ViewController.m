//
//  ViewController.m
//  SMProgressHUD
//
//  Created by OrangeLife on 15/10/9.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "ViewController.h"
#import "SMProgressHUD.h"
#import "SMProgressHUDActionSheet.h"

@interface ViewController ()<SMProgressHUDAlertViewDelegate, SMProgressHUDActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)showLoading:(id)sender
{
    [[SMProgressHUD shareInstancetype] showLoading];
}

- (IBAction)showLoadingWithText:(id)sender {
    [[SMProgressHUD shareInstancetype] showLoadingWithTip:@"Loading..."];
}

- (IBAction)showAlertView:(id)sender {
    [[SMProgressHUD shareInstancetype]
     showAlertWithTitle:@"Title"
     message:@"Life is too short to waste. Dreams are fulfilled only through action, not through endless planning to take action."
     delegate:nil
     alertStyle:SMProgressHUDAlertViewStyleDefault
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@[@"Sure"] ];
}
- (IBAction)showActionSheet:(id)sender
{
    [[SMProgressHUD shareInstancetype]
     showActionSheetWithTitle:@"Please choose the event you need? "
     delegate:self
     cancelButtonTitle:@"Cancel"
     destructiveButtonTitle:@"Sure"
     otherButtonTitles:@[@"Loading",@"Tip",@"Alert"]
     userInfo:nil];
}

- (IBAction)showAlertViewWithInput:(id)sender {
    [[SMProgressHUD shareInstancetype]
     showAlertWithTitle:@"Title"
     message:@"Life is too short to waste. Dreams are fulfilled only through action, not through endless planning to take action."
     delegate:nil
     alertStyle:SMProgressHUDAlertViewStyleLoginAndPasswordInput
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@[@"Confrim",@"Go"] ];
}

- (void)alertView:(SMProgressHUDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Click The Button At %ld", (long)buttonIndex);
    [self showLoadingWithTip:nil];
}

- (IBAction)showTip:(id)sender {
    [[SMProgressHUD shareInstancetype] showTip:@"Life is too short to waste. Dreams are fulfilled only through action, not through endless planning to take action."];
}
- (IBAction)showLoadingWithTip:(id)sender {
    [[SMProgressHUD shareInstancetype] showLoadingWithTip:nil];
    [self performSelector:@selector(showTip:) withObject:nil afterDelay:5];
}

- (IBAction)showAlertLoadingTip:(id)sender {
    [[SMProgressHUD shareInstancetype]
     showAlertWithTitle:@"Title"
     message:@"Life is too short to waste. Dreams are fulfilled only through action, not through endless planning to take action."
     delegate:self
     alertStyle:SMProgressHUDAlertViewStyleDefault
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@[@"Confrim",@"Go"] ];
}

- (IBAction)showThreeLoading:(id)sender {
    [self showLoading:nil];
    [self performSelector:@selector(showLoading:) withObject:nil afterDelay:10];
    [self performSelector:@selector(showLoading:) withObject:nil afterDelay:20];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:10];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:20];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:30];
}

- (void)dismiss
{
    [[SMProgressHUD shareInstancetype] dismissLoadingView];
}


- (IBAction)showDoneTip:(id)sender {
    [[SMProgressHUD shareInstancetype] showDoneTip:@"Done"];
    
}
- (IBAction)showErrorTip:(id)sender {
     [[SMProgressHUD shareInstancetype] showErrorTip:@"Error"];
}
- (IBAction)showWarning:(id)sender {
    [[SMProgressHUD shareInstancetype] showWarningTip:@"Warning"];
}

-(void)actionSheetView:(SMProgressHUDActionSheet*)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionsheet-buttonIndex:%d", buttonIndex);
    if (buttonIndex == 2)
    {
        [self showLoading:nil];
    }
    else if(buttonIndex == 3)
    {
        [self showTip:nil];
    }
    else if(buttonIndex == 4)
    {
        [self showAlertView:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
