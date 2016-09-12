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
-(NSData *)FileDownload:(NSString *)mediaid suffix:(NSString *)suffix mediatype:(NSString *)mediatype;
-(ReturnData *)uploadfile:(NSData *)filedata mediaid:(NSString *)mediaid mediatype:(NSString *)mediatype
                 filetype:(NSString *)filetype;
-(ReturnData *)UpdateUserImg:(NSString *)mediaid;

-(ReturnData *)ModiPwd:(NSString *)oldpwd newpwd:(NSString *)newpwd;

//得到部门信息
-(BOOL)getdepartmentinfo;
//得到部门用户信息
-(BOOL)getdepartmentUserinfo;

//获取审批人
-(ReturnData *)queryApproveUserList;
//查询调度信息列表
-(BOOL)getGroupsList;

//发布调度信息
-(ReturnData *)publishJDInfo:(NSString *)title content:(NSString*)content recordfile:(NSString *)recordId pics:(NSString *)picsid group_ids:(NSString *)group_ids approve_account_id:(NSString *)approve_account_id;

//更新ios Token
-(void)UpdateIOSToken:(NSString*)token;


//查询审核信息
-(NSArray *)getAppoverMsg;

-(BOOL)ApproveDispatchMsg:(NSString *)dispatch_id approve_result:(NSString *)approve_result approve_desc:(NSString *)approve_desc send_account_id:(NSString *)send_account_id send_user_name:(NSString *)send_user_name;
@end
