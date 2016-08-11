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
#import "ServerInfo.h"

@interface HttpServer : NSObject
{
    NSString *url;
}
-(instancetype)init:(NSString *)Url;

//登录
-(NSDictionary *)Login:(NSString *)username userpwd:(NSString *)pwd;
-(BOOL)FileDownload:(NSString *)mediaid suffix:(NSString *)suffix mediatype:(NSString *)mediatype;
-(ReturnData *)uploadfile:(NSData *)filedata mediaid:(NSString *)mediaid mediatype:(NSString *)mediatype;
-(ReturnData *)UpdateUserImg:(NSString *)mediaid;


@end
