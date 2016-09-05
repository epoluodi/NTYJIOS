//
//  ServerInfo.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTServer.h"
#define ServerUrl @"http://192.168.0.122:8080/ntyj"
//#define ServerUrl @"http://15b2060o22.iask.in:18080/ntyj" //test
#define APP @"/app/"
#define IM @"/im/"
#define AUTH @"/auth/"
#define API @"/api/"
#define UPDATEAPP @"/upgrade/"

#define APPURL [NSString stringWithFormat:@"%@%@",ServerUrl,APP]
#define IMURL [NSString stringWithFormat:@"%@%@",ServerUrl,IM]
#define AUTHURL [NSString stringWithFormat:@"%@%@",ServerUrl,AUTH]
#define APIURL [NSString stringWithFormat:@"%@%@",ServerUrl,API]
#define UPDATEAPPURL [NSString stringWithFormat:@"%@%@",ServerUrl,UPDATEAPP]

#define LoginUrl [NSString stringWithFormat:@"%@%@",AUTHURL,@"getToken"]
#define DownloadUrl [NSString stringWithFormat:@"%@%@",APIURL,@"download"]
#define UploadUrl [NSString stringWithFormat:@"%@%@",APIURL,@"upload"]
#define UpdateUserNickImg [NSString stringWithFormat:@"%@%@",APPURL,@"user/savePicture"]
#define SavePwd [NSString stringWithFormat:@"%@%@",APPURL,@"user/savePwd"]

#define queryGroups [NSString stringWithFormat:@"%@%@",IMURL,@"group/queryGroups"]
#define queryUsers [NSString stringWithFormat:@"%@%@",APPURL,@"user/queryUsers"]

#define queryGroupsAndDispatchs [NSString stringWithFormat:@"%@%@",IMURL,@"group/queryGroupsAndDispatchs"]

#define queryApproveUsers [NSString stringWithFormat:@"%@%@",APPURL,@"user/queryApproveUsers"]




@interface ServerInfo : NSObject


@property (copy,nonatomic)NSString *MQTTADDRESS;
@property (assign)INT_PORT MQTTPORT;
@property (copy,nonatomic)NSString *username;
@property (copy,nonatomic)NSString *password;

+(instancetype)getInstance;




@end
