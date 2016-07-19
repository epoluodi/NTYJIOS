//
//  HttpServer.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "HttpServer.h"
#import "UserInfo.h"

@implementation HttpServer


-(instancetype)init:(NSString *)Url
{
    self = [super init];
    url=Url;
    return  self;
    
}




-(NSDictionary *)Login:(NSString *)username userpwd:(NSString *)pwd
{
    HttpClass *http = [[HttpClass alloc] init:url];
    [http setIsHead:YES];
    [http addHeadString:@"deviceID" value:[UserInfo getInstance].deviceid];
    [http addHeadString:@"deviceType" value:@"01"];
    
    [http addParamsString:@"username" values:username];
    [http addParamsString:@"password" values:pwd];
    NSData *data = [http httprequest:[http getDataForArrary]];
    if (!data)
        return nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
}


@end
