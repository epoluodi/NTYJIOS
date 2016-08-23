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
    _IsMQTTConnect = NO;
    return self;
}


-(void)PublishGroupTopic:(NSString *)topic
{
    [mqttclient subscribe:topic withQos:AtMostOnce completionHandler:^(NSArray *grantedQos) {
        NSLog(@"订阅结果 %@",grantedQos);
    }];
}

//连接MQTT
-(void)ConnectMqtt:(NSString *)username password:(NSString *)password
{
    [mqttclient connectWithCompletionHandler:username andPassword:password andCallBack:^(MQTTConnectionReturnCode code) {
        if (code==0)
        {
            _IsMQTTConnect = YES;
            [_delegate OnConnectMqtt];
            
        }
        else
        {
            _IsMQTTConnect = NO;
            [_delegate OnConnectError];
        }
    }];
}

//MQTT断开
-(void)DisConncectMqtt
{
         _IsMQTTConnect = NO;
}
@end
