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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak,nonatomic) MQTTServer *mqtt;

@end

