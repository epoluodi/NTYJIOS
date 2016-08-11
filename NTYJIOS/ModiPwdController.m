//
//  ModiPwdController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ModiPwdController.h"
#import "UserInfo.h"

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的登录密码，并且新密码不能为空" delegate:nil cancelButtonTitle:@"" otherButtonTitles: nil];
    
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
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}

@end
