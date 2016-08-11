//
//  HttpServer.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "HttpServer.h"
#import "UserInfo.h"
#import <Common/FileCommon.h>

@implementation HttpServer


-(instancetype)init:(NSString *)Url
{
    self = [super init];
    url=Url;
    return  self;
    
}



//登录
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

//文件下载
-(BOOL)FileDownload:(NSString *)mediaid suffix:(NSString *)suffix mediatype:(NSString *)mediatype
{
    HttpClass *http = [[HttpClass alloc] init:url];
    [http setIsHead:YES];
    [http addHeadString:@"deviceID" value:[UserInfo getInstance].deviceid];
    [http addHeadString:@"deviceType" value:@"01"];
    [http addHeadString:@"token" value:[UserInfo getInstance].Token];
    
    [http addParamsString:@"mediaId" values:mediaid];
    [http addParamsString:@"suffix" values:suffix];
    NSData *data = [http httprequest:[http getDataForArrary]];
    if (!data)
        return NO;
    
    [UserInfo getInstance].nickimg = [UIImage imageWithData:data];
    NSFileManager *filenamger = [NSFileManager defaultManager];
    NSString *path = [FileCommon getCacheDirectory];
    NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",mediaid,mediatype]];
    [filenamger createFileAtPath:_filename contents:data attributes:nil];
    return YES;
    
    
    
}

//上传
-(ReturnData *)uploadfile:(NSData *)filedata mediaid:(NSString *)mediaid mediatype:(NSString *)mediatype
{
    HttpClass *http = [[HttpClass alloc] init:url];
    [http setIsHead:YES];
    [http addHeadString:@"deviceID" value:[UserInfo getInstance].deviceid];
    [http addHeadString:@"deviceType" value:@"01"];
    [http addHeadString:@"token" value:[UserInfo getInstance].Token];
    [http addHeadString:@"mediaId" value:mediaid];
    [http addHeadString:@"mediaType" value:mediatype];
    

    NSData *d = [http UploadFile:mediaid FileData:filedata];
  
    if (!d)
        return nil;
    ReturnData *rd = [ReturnData getReturnDatawithData:d dataMode:YES];
    return rd;

}


//更新头像
-(ReturnData *)UpdateUserImg:(NSString *)mediaid
{
    HttpClass *http = [[HttpClass alloc] init:url];
    [http setIsHead:YES];
    [http addHeadString:@"deviceID" value:[UserInfo getInstance].deviceid];
    [http addHeadString:@"deviceType" value:@"01"];
    [http addHeadString:@"token" value:[UserInfo getInstance].Token];
    
    [http addParamsString:@"oldMediaId" values:[UserInfo getInstance].picture];
    [http addParamsString:@"mediaId" values:mediaid];
    
    
    NSData *d = [http httprequest:[http getDataForArrary]];
    
    if (!d)
        return nil;
    ReturnData *rd = [ReturnData getReturnDatawithData:d dataMode:YES];
    return rd;







}
@end
