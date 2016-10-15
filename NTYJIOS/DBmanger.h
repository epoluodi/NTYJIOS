//
//  DBmanger.h
//  DyingWish
//
//  Created by xiaoguang yang on 15-4-2.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Department.h"
#import "Contacts.h"
#import "DDInfo.h"
#import "ChatLog+CoreDataClass.h"


@interface DBmanger : NSObject
{
    NSManagedObjectContext *mangedcontext;
    NSManagedObjectModel *mangedobjectmodel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
}




-(instancetype)initDB;
+(instancetype)getIntance;


-(void)addDepartment:(NSString *)name departmentid:(NSString *)departmentid;
//添加用户信息
-(void)addDepartmentUserInfo:(NSDictionary *)userinfo;
-(void)deletUserInfo;
-(void)deletDepartment;
-(NSArray *)getDeparment;
-(NSArray *)getContactswithDepartment:(NSString *)dpid;
-(NSArray *)getContactswithPY:(NSString *)PY;
-(NSArray *)getContactForSearch:(NSString *)key;
-(NSArray *)getfirstlatter;
-(void)deletejdinfo;
-(void)addJDinfo:(NSDictionary *)jdinfo;
-(NSArray *)getDDinfo;
-(Contacts *)getContactswithuserId:(NSString *)userid;
-(ChatLog *)addChatLog:(NSDictionary *)chatdata;
-(NSArray *)getChatLog:(NSString *)groupid;
@end
