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
#import <BaiduMapAPI_Location/BMKLocationComponent.h>



@interface MainTabBarController : UITabBarController<MQTTDelegate,BMKLocationServiceDelegate>
{
    MQTTServer *mqtt;
    BMKLocationService* _locService;
}
@property (assign)BOOL IsLogin;
@property (weak,nonatomic)UIViewController *nowVC;

-(void)ConnectMqtt;
-(void)DisConnectMqtt;

@end
