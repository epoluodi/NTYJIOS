//
//  UserInfo.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserInfo : NSObject


@property (copy,nonatomic)NSString *Token;
@property (copy,nonatomic)NSString *userName;
@property (copy,nonatomic)NSString *userId;
@property (copy,nonatomic)NSString *sex;
@property (copy,nonatomic)NSString *positionId;
@property (copy,nonatomic)NSString *positionName;
@property (copy,nonatomic)NSString *tel;
@property (copy,nonatomic)NSString *sysUserName;
@property (copy,nonatomic)NSString *picture;
@property (copy,nonatomic)NSArray *auth;
@property (copy,nonatomic)UIImage *nickimg;
@property (copy,nonatomic)NSString *deviceid;
//获得静态方法
+(instancetype)getInstance;

@end
