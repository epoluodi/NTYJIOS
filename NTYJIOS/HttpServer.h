//
//  HttpServer.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClass.h"
#import "ReturnData.h"

@interface HttpServer : NSObject
{
    NSString *url;
}
-(instancetype)init:(NSString *)Url;

//登录
-(NSDictionary *)Login:(NSString *)username userpwd:(NSString *)pwd;


@end
