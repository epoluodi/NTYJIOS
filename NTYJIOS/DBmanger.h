//
//  DBmanger.h
//  DyingWish
//
//  Created by xiaoguang yang on 15-4-2.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



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




@end
