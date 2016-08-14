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

@interface MainTabBarController ()

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
            
            [self presentViewController:loginVC animated:YES completion:nil];
            
            
        });
    });
    
    // Do any additional setup after loading the view.
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