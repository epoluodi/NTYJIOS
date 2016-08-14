//
//  ModiPwdController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ModiPwdController.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import "HttpServer.h"

@implementation ModiPwdController
@synthesize navbar;
@synthesize pwd,newpwd,newpwd2;

-(void)viewDidLoad
{
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    
    btnconfim = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ClickConfim)];
    [btnconfim setTintColor :[UIColor whiteColor] ];
    
    
    UINavigationItem *item = navbar.items[0];
    [item setLeftBarButtonItem:btnreturn];
    [item setRightBarButtonItem:btnconfim];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)ClickConfim
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的登录密码，并且新密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    if (![[UserInfo getInstance].userPwd isEqualToString:pwd.text])
    {
        [alert show];
        return;
    }
    
    if (![newpwd.text isEqualToString:newpwd2.text] &&
        ![newpwd.text isEqualToString:@""])
    {
        [alert show];
        return;
    }
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    MBProgressHUD *hub=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    [hub show:YES];
    
    dispatch_async(globalQ, ^{
        HttpServer *http =[[HttpServer alloc] init:SavePwd];
        ReturnData *rd=  [http ModiPwd:pwd.text newpwd:newpwd.text];
        dispatch_async(mainQ, ^{
            [hub hide:YES];
            if (!rd)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改错误，请重新尝试修改密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return ;
            }
            if (rd.returnCode == 0 )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改错误，请重新尝试修改密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        });
    });
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//}

@end
