//
//  UserInfoController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "UserInfoController.h"

@implementation UserInfoController
@synthesize navbar,table;
@synthesize IsSelf,userid;
-(void)viewDidLoad
{
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    UINavigationItem *item = navbar.items[0];
    item.title=@"个人信息";
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


@end
