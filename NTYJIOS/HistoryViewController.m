//
//  HistoryViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/11/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "HistoryViewController.h"
#import <Common/PublicCommon.h>
#import "MBProgressHUD.h"


@interface HistoryViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation HistoryViewController
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(Onright:)];
    btnright.tintColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    table.backgroundColor = [UIColor clearColor];
    
    
    //    [title setLeftBarButtonItem:btnleft];
    [self.navigationItem setRightBarButtonItem:btnright];
    self.tabBarController.tabBar.hidden=YES;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    // Do any additional setup after loading the view.
}







-(void)Onright:(id)sender
{
    
    
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                              withMenu:@[@"一个月内",@"三个月内",@"一年内"]
                        imageNameArray:@[@"month",@"month3",@"year"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 
                                 switch (selectedIndex) {
                                     case 0://发布
                                         
                                       
                                         break;
                                     case 1:
                                      
                                         break;
                                 }
                                 
                             } dismissBlock:^{
                                 
                                 NSLog(@"user canceled. do nothing.");
                                 
                             }];
}




-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
