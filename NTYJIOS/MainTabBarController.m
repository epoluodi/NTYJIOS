//
//  MainTabBarController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MainTabBarController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "MessageViewContoller.h"
#import "AppDelegate.h"
#import "ReturnData.h"


@interface MainTabBarController ()
{   AppDelegate *app;
    MessageViewContoller *vc1;
}
@end

@implementation MainTabBarController
@synthesize IsLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor=APPCOLOR;
    IsLogin = NO;
 
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
        dispatch_async(mainQ, ^{
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVC.mainview=self;
            [self presentViewController:loginVC animated:YES completion:nil];
            
            
        });
    });
    
    vc1 = (MessageViewContoller *)((UINavigationController *)self.viewControllers[0]).topViewController;
    // Do any additional setup after loading the view.
}


-(void)ConnectMqtt
{
    
    mqtt = [[MQTTServer alloc] init:[ServerInfo getInstance].MQTTADDRESS port:[ServerInfo getInstance].MQTTPORT];
    mqtt.delegate = self;
    [mqtt  ConnectMqtt:[ServerInfo getInstance].username password:[ServerInfo getInstance].password];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.mqtt=mqtt;
}



-(void)OnConnectMqtt
{
    NSLog(@"连接成功");
    [app.mqtt PublishGroupTopic:[UserInfo getInstance].userId];

  
    
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(mainQ, ^{
        [vc1 loadDDinfo];
    });
    
    
}
-(void)DisConnectMqtt
{
    [mqtt DisConncectMqtt];
}
-(void)OnConnectError
{
    NSLog(@"连接错误");
}

-(void)OnDisConnect
{
    NSLog(@"连接断开");
}

-(void)OnMessage:(NSString *)msg
{
  
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    ReturnData *returndata = [ReturnData getReturnData:msg dataMode:YES];
    
    NSLog(@"接收到MQTT信息:%@",returndata.returnData);
    
    NSString *scope =[returndata.returnData objectForKey:@"scope"];

    
    if ([scope isEqualToString:@"system"])
    {
        NSDictionary *msgbody =[returndata.returnData objectForKey:@"msgBody"];
        int optcode =[[msgbody objectForKey:@"optCode"] intValue];
        NSDictionary *optdata;
        
        if (optcode==1)
        {
                optdata = [msgbody objectForKey:@"optData"];
                dispatch_async(mainQ, ^{
                    self.selectedIndex=0;
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"新的调度信息" message:[optdata objectForKey:@"dispatch_title"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    
                    [vc1 loadDDinfo];
                });
            return;
        }
        //提醒
        if (optcode==6)
        {
            optdata = [msgbody objectForKey:@"optData"];
            dispatch_async(mainQ, ^{
                self.selectedIndex=0;
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提醒：调度信息" message:[optdata objectForKey:@"dispatch_title"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
           
            });
            return;
        }
        //拒绝
        if (optcode==5)
        {
            optdata = [msgbody objectForKey:@"optData"];
            dispatch_async(mainQ, ^{
                self.selectedIndex=0;
                NSString *desc = [NSString stringWithFormat:@"审批人：%@ 审批原因:%@",
                                 [optdata objectForKey:@"approve_user_name"],
                                  [optdata objectForKey:@"approve_desc"] ];
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"调度信息审批拒绝" message:desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            });
            return;
        }
        
        //关闭调度
        if (optcode==3)
        {
            optdata = [msgbody objectForKey:@"optData"];
            dispatch_async(mainQ, ^{
                self.selectedIndex=0;
                NSString *desc = [NSString stringWithFormat:@"审批人：%@ 调度标题:%@",
                                  [optdata objectForKey:@"send_user_name"],
                                  [optdata objectForKey:@"dispatch_title"] ];
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"调度信息关闭" message:desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [vc1 loadDDinfo];
            });
            return;
        }
        
        
    }
    
    
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
