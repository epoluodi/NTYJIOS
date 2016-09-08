//
//  UserInfo.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize Token;
@synthesize userName,userId,userPwd;
@synthesize sex;
@synthesize positionId,positionName;
@synthesize tel;
@synthesize sysUserName;
@synthesize picture,nickimg;
@synthesize deviceid;
@synthesize auth;
@synthesize deparmentname;

static UserInfo *_userinfo;


+(instancetype)getInstance
{
    if (!_userinfo){
        _userinfo = [[UserInfo alloc] init];
        
    }
    return _userinfo;
}


-(NSString *)getLineMessage
{
    NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:userId ,@"userId", nil];
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}



@end
