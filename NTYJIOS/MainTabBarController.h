//
//  MainTabBarController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MQTTServer.h"
#import "AppDelegate.h"



@interface MainTabBarController : UITabBarController<MQTTDelegate>
{
    MQTTServer *mqtt;
}
@property (assign)BOOL IsLogin;


-(void)ConnectMqtt;
@end
