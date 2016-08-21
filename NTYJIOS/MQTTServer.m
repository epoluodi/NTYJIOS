//
//  MQTTServer.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MQTTServer.h"


@implementation MQTTServer


//初始化
-(instancetype)init:(NSString *)host port:(INT_PORT)port
{
    self = [super init];
    mqttclient = [[MQTTClient alloc] initWithClientId:[UIDevice currentDevice].identifierForVendor.UUIDString cleanSession:YES];
    mqttclient.host=host;
    mqttclient.port=port;
    return self;
}



//连接MQTT
-(void)ConnectMqtt:(NSString *)username password:(NSString *)password
{
    [mqttclient connectWithCompletionHandler:username andPassword:password andCallBack:^(MQTTConnectionReturnCode code) {
        if (code==0)
        {
            [_delegate OnConnectMqtt];
            
        }
        else
        {
            [_delegate OnConnectError];
        }
    }];
}

//MQTT断开
-(void)DisConncectMqtt
{
    
}
@end
