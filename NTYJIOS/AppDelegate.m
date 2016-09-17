//
//  AppDelegate.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "AppDelegate.h"
#import <Common/PublicCommon.h>
#import "Common.h"
#import "DBmanger.h"
#import "HttpServer.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mqtt;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DBmanger getIntance];
    UIImage *backbar = [PublicCommon createImageWithColor:APPCOLOR Rect:CGRectMake(0, 0, 100, 100)];
    
    [[UINavigationBar appearance] setBackgroundImage:backbar forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UserInfo getInstance];

    [UserInfo getInstance].deviceid=[[UIDevice currentDevice].identifierForVendor UUIDString];
    [ServerInfo getInstance];
    [self initLoginInfo];
    

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    
    
     [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入
    
    // Override point for customization after application launch.
    return YES;
}


-(void)initLoginInfo
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    BOOL isfirstrunn =[userinfo boolForKey:@"isFirstRun"];
    if (!isfirstrunn)
    {
        [userinfo setObject:@"" forKey:@"username"];
        [userinfo setObject:@"" forKey:@"userpwd"];
        [userinfo setBool:YES forKey:@"isFirstRun"];
    }
    else
    {
        [UserInfo getInstance].sysUserName =[userinfo objectForKey:@"username"];
        [UserInfo getInstance].userPwd =[userinfo objectForKey:@"userpwd"];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    iostoken = [[[[deviceToken description]
                   stringByReplacingOccurrencesOfString:@"<" withString:@""]
                  stringByReplacingOccurrencesOfString:@">" withString:@""]
                 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"推送toekn %@",iostoken);
    
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ, ^{
        HttpServer *http =[[HttpServer alloc] init:setIosToken];
        [http UpdateIOSToken:iostoken];
    });
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"远程通知 %@",userInfo);
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    sleep(1);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
