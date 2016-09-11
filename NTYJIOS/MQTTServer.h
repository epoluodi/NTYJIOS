//
//  MQTTServer.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTKit.h"
#import <UIKit/UIKit.h>


@protocol MQTTDelegate


-(void)OnMessage:(NSString *)msg;

@optional
-(void)OnConnectMqtt;
-(void)OnDisConnect;
-(void)OnConnectError;


@end

typedef unsigned short INT_PORT;

@interface MQTTServer : NSObject
{
    MQTTClient *mqttclient;
    __block __weak MQTTServer *blockself;
}

@property  (nonatomic,weak) __block NSObject<MQTTDelegate> *delegate;
@property (assign)BOOL IsMQTTConnect;

-(instancetype)init:(NSString *)host port:(INT_PORT)port;



//连接mqtt
-(void)ConnectMqtt:(NSString *)username password:(NSString *)password;

//断开MQTT连接
-(void)DisConncectMqtt;

//订阅
-(void)PublishGroupTopic:(NSString *)topic;
-(void)sendMessage:(NSString *)topic content:(NSString *)content;
@end
