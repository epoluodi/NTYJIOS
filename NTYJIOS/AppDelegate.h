//
//  AppDelegate.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MQTTServer.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <BMKGeneralDelegate,UIApplicationDelegate>
{
    NSString *iostoken;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (weak,nonatomic) MQTTServer *mqtt;
@property (copy,nonatomic)BMKUserLocation *loc;

@end

