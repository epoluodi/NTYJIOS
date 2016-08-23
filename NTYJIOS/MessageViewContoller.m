//
//  MessageViewContoller.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MessageViewContoller.h"
#import "FTPopOverMenu.h"
#import "HttpServer.h"
#import "UserInfo.h"
#import "AppDelegate.h"

@interface MessageViewContoller ()
{
    AppDelegate *app;
}
@end

@implementation MessageViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    app = [[UIApplication sharedApplication] delegate];
    
    
    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(Onright:)];
    btnright.tintColor = [UIColor whiteColor];
    
    btnleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"appover"] style:UIBarButtonItemStylePlain target:self action:@selector(Onleft)];
    btnleft.tintColor = [UIColor redColor];
    
    
    title = [[UINavigationItem alloc] initWithTitle:@"调度信息"];
    title.hidesBackButton=YES;
    
    
    [title setLeftBarButtonItem:btnleft];
    [title setRightBarButtonItem:btnright];
    
    [self.navigationController.navigationBar pushNavigationItem:title animated:YES];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)Onright:(id)sender
{
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                        withMenu:@[@"发布调度",@"历史调度",]
                  imageNameArray:@[@"publishjd",@"historyjd"]
                       doneBlock:^(NSInteger selectedIndex) {
                           
                           NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
                           
                       } dismissBlock:^{
                           
                           NSLog(@"user canceled. do nothing.");
                           
                       }];
}
-(void)Onleft
{
    
}

-(void)loadDDinfo
{
    HttpServer *http =[[HttpServer alloc] init:queryGroupsAndDispatchs];
    BOOL result = [http getGroupsList];
    if (!result)
    {
        
        return;
    }
}

//加载数据
-(void)viewWillAppear:(BOOL)animated
{
 
    NSLog(@"显示");
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
