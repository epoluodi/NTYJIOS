//
//  ServerInfo.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServerUrl @"http://192.168.1.80:8080"
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


@interface ServerInfo : NSObject

@property (copy,nonatomic)NSString *MQTTADDRESS;
@property (copy,nonatomic)NSString *username;
@property (copy,nonatomic)NSString *password;

+(instancetype)getInstance;
@end
