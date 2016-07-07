//
//  ServerInfo.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ServerInfo.h"

@implementation ServerInfo
@synthesize MQTTADDRESS,username,password;


static ServerInfo *_serverinfo;

+(instancetype)getInstance
{
    if (!_serverinfo){
        _serverinfo = [[ServerInfo alloc] init];
        
    }
    return _serverinfo;
}
@end
