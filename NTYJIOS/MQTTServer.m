//
//  MQTTServer.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MQTTServer.h"
#import "UserInfo.h"
#define    offlineTopic @"topic/offline"
#define    onlineTopic  @"topic/online"



@implementation MQTTServer


//初始化
-(instancetype)init:(NSString *)host port:(INT_PORT)port
{
    self = [super init];
    mqttclient = [[MQTTClient alloc] initWithClientId:[UIDevice currentDevice].identifierForVendor.UUIDString cleanSession:YES];
    mqttclient.host=host;
    mqttclient.port=port;
    _IsMQTTConnect = NO;
    blockself =self;
    [self setMessage];
    [self DisConntectEvent];
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
    
    [mqttclient setWill:[[UserInfo getInstance] getLineMessage] toTopic:offlineTopic withQos:AtLeastOnce retain:NO];
    
    [mqttclient connectWithCompletionHandler:username andPassword:password andCallBack:^(MQTTConnectionReturnCode code) {
        if (code==0)
        {
            _IsMQTTConnect = YES;
            [ blockself->_delegate OnConnectMqtt];
            [mqttclient publishString:[[UserInfo getInstance] getLineMessage]  toTopic:onlineTopic withQos:ExactlyOnce retain:NO completionHandler:nil];
        }
        else
        {
            _IsMQTTConnect = NO;
            [ blockself->_delegate OnConnectError];
        }
    }];
}

//MQTT断开
-(void)DisConncectMqtt
{
    [mqttclient publishString:[[UserInfo getInstance] getLineMessage]  toTopic:offlineTopic withQos:ExactlyOnce retain:NO completionHandler:nil];
    [mqttclient disconnectWithCompletionHandler:nil];
         _IsMQTTConnect = NO;
    
    
    
}

-(void)setMessage
{
    //MQTTMessage  里面的数据接收到的是二进制，这里框架将其封装成了字符串
    [mqttclient setMessageHandler:^(MQTTMessage* message)
     {
         dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(globalQ, ^{
             //接收到消息，更新界面时需要切换回主线程
             NSLog(@"收到的信息MQTT:%@--->%@",message.topic, [message payloadString]);

                 [blockself->_delegate OnMessage:[message payloadString]];
         });
     }];
}

//设置断开监听
-(void)DisConntectEvent
{
    [mqttclient setDisconnectionHandler:^(NSUInteger code){
        NSLog(@"断开mqtt %lu",(unsigned long)code);
        _IsMQTTConnect=NO;
        [ blockself->_delegate OnDisConnect];
    }];
}
@end
