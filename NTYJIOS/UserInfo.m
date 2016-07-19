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
@synthesize userName,userId;
@synthesize sex;
@synthesize positionId,positionName;
@synthesize tel;
@synthesize sysUserName;
@synthesize picture,nickimg;
@synthesize deviceid;

static UserInfo *_userinfo;


+(instancetype)getInstance
{
    if (!_userinfo){
        _userinfo = [[UserInfo alloc] init];
        
    }
    return _userinfo;
}






@end
