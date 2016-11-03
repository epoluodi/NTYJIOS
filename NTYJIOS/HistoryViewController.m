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
#import "HttpServer.h"


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
    [self getHisoryData:@"01"];
    // Do any additional setup after loading the view.
}


-(void)getHisoryData:(NSString *)timetype
{
    [self.view addSubview:hud];
    [hud show:YES];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
       
        HttpServer *http = [[HttpServer alloc] init:queryHisDispatchMsgs];
       ReturnData *rd =  [http queryHistoryJD:timetype];
        dispatch_async(mainQ, ^{
            [hud hide:YES];
            if (!rd)
            {
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取历史调度信息失败!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            
            jsondata = rd.returnDatas;
            NSLog(@"历史数据 %@",jsondata);
            
            
        });
        
    });
    
}





-(void)Onright:(id)sender
{
    
    
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                              withMenu:@[@"一个月内",@"三个月内",@"一年内"]
                        imageNameArray:@[@"month",@"month3",@"year"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 
                                 switch (selectedIndex) {
                                     case 0://发布
                                         [self getHisoryData:@"01"];
                                         
                                         break;
                                     case 1:
                                         [self getHisoryData:@"02"];
                                         break;
                                     case 2:
                                         [self getHisoryData:@"03"];
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
