//
//  ModiPwdController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ModiPwdController.h"

@implementation ModiPwdController
@synthesize navbar;
@synthesize pwd,newpwd,newpwd2;

-(void)viewDidLoad
{
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    UINavigationItem *item = navbar.items[0];
    [item setLeftBarButtonItem:btnreturn];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}

@end
