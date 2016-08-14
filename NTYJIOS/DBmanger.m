//
//  DBmanger.m
//  DyingWish
//
//  Created by xiaoguang yang on 15-4-2.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

#import "DBmanger.h"
#import <Common/FileCommon.h>


@implementation DBmanger


static DBmanger *_db;


+(instancetype)getIntance
{
    if (!_db)
        _db = [[DBmanger alloc] initDB];
    return _db;
}

-(instancetype)initDB
{
    
    self = [super init];
    
    mangedcontext = [[NSManagedObjectContext alloc] init];
    mangedcontext.persistentStoreCoordinator = [self persistentstorecoordinator];
    
    return self;
}

-(NSPersistentStoreCoordinator*)persistentstorecoordinator
{
    NSString * modelpath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"momd"];
    mangedobjectmodel = [[NSManagedObjectModel alloc]initWithContentsOfURL:[NSURL fileURLWithPath:modelpath]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mangedobjectmodel];
    NSString *docs = [FileCommon getCacheDirectory];
    
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Main.db"]];//要存得数据文件名
    
    
    
    NSError *error = nil;
    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        return nil;
    }
    return persistentStoreCoordinator;
    
}

//插入部门数据
-(void)addDepartment:(NSString *)name departmentid:(NSString *)departmentid
{
    Department *dp = [NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:mangedcontext];
    
    [dp setValue:name forKey:@"name"];
    [dp setValue:departmentid forKey:@"departmentid"];
    [mangedcontext save:nil];

}


//删除部门
-(void)deletDepartment
{
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Department"];
    
    //排序
    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
    //    fetch.sortDescriptors=@[sort];
    //加入查询条件 age>20
    //    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcode=%@",stockcode];
    
    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
    for (Department *obj in arr)
    {
        [mangedcontext deleteObject:obj];
    }
    [mangedcontext save:nil];
    return ;
}




//添加用户信息
-(void)addDepartmentUserInfo:(NSDictionary *)userinfo
{
    Contacts *contacts = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:mangedcontext];
    
    if ([userinfo objectForKey:@"tel"]  == [NSNull null])
        [contacts setValue:@"" forKey:@"tel"];
    else
        [contacts setValue:[userinfo objectForKey:@"tel"] forKey:@"tel"];
    [contacts setValue:[userinfo objectForKey:@"accountId"] forKey:@"userid"];
    [contacts setValue:[userinfo objectForKey:@"name"] forKey:@"name"];
    [contacts setValue:[userinfo objectForKey:@"sysUserName"] forKey:@"loginname"];
    [contacts setValue:[userinfo objectForKey:@"sex"] forKey:@"sex"];
    [contacts setValue:[userinfo objectForKey:@"firstLetter"] forKey:@"firstLetter"];
    if ([userinfo objectForKey:@"picture"]  == [NSNull null])
        [contacts setValue:@"" forKey:@"img"];
    else
        [contacts setValue:[userinfo objectForKey:@"picture"] forKey:@"img"];
    [contacts setValue:[userinfo objectForKey:@"positionId"] forKey:@"positionid"];
    [contacts setValue:[userinfo objectForKey:@"positionName"] forKey:@"positionname"];
    NSArray *groups = [userinfo objectForKey:@"groups"];
    NSMutableString *_groupids,*_groupnames;
    _groupids = [[NSMutableString alloc] init];
    _groupnames = [[NSMutableString alloc] init];
    
    for (NSDictionary *group in groups) {
        [_groupids appendString:[group objectForKey:@"GROUP_ID"]];
        [_groupids appendString:@","];
        
        [_groupnames appendString:[group objectForKey:@"GROUP_NAME"]];
        [_groupnames appendString:@","];
        
    }
    if ([_groupids isEqualToString:@""])
        [contacts setValue:@"" forKey:@"groupid"];
    else
        [contacts setValue: [_groupids substringToIndex:_groupids.length-1] forKey:@"groupid"];
    if ([_groupnames isEqualToString:@""])
            [contacts setValue: @"" forKey:@"groupname"];
    else
        [contacts setValue: [_groupnames substringToIndex:_groupnames.length-1] forKey:@"groupname"];
    
    [mangedcontext save:nil];
}



-(void)deletUserInfo
{

    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Contacts"];

    //排序
    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
    //    fetch.sortDescriptors=@[sort];
    //加入查询条件 age>20
//    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcode=%@",stockcode];

    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
    for (Contacts *obj in arr)
    {
        [mangedcontext deleteObject:obj];
    }
    [mangedcontext save:nil];
    return ;
}



//获得部门信息
-(NSArray *)getDeparment
{
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Department"];

    //排序
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
        fetch.sortDescriptors=@[sort];
    //加入查询条件 age>20
//    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcode=%@",stockcode];

    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];

    return arr;
}



//
//
//-(int)finddata:(NSString *)stockcode{
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Stock"];
//
//    //排序
////    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
////    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
//        fetch.predicate=[NSPredicate predicateWithFormat:@"stockcode=%@",stockcode];
//
////    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    int l = (int)arr.count;
//    NSLog(@"找到的数据： %d",l);
//    return l;
//}
//
//
//
//
//
//-(int)getDingDongs{
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"StockDD"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
////    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcode=%@",stockcode];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    int l = (int)arr.count;
//    NSLog(@"叮咚总数： %d",l);
//    return l;
//}
//
//
//
//-(void)updateDingDongs:(NSString *)stockcodeEx l1:(NSString *)l1 l2:(NSString*)l2{
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"StockDD"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
//        fetch.predicate=[NSPredicate predicateWithFormat:@"stockcodeEx=%@",stockcodeEx];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    StockDD * sdd;
//    if ([arr count] == 0)
//    {
//        sdd = [NSEntityDescription insertNewObjectForEntityForName:@"StockDD" inManagedObjectContext:mangedcontext];
//
//        [sdd setValue:stockcodeEx forKey:@"stockcodeEx"];
//        [sdd setValue:l1 forKey:@"l1"];
//        [sdd setValue:l2 forKey:@"l2"];
//
//    }
//    else
//    {
//        sdd= [arr objectAtIndex:0];
//        sdd.l1 = l1;
//        sdd.l2=l2;
//
//    }
//    [mangedcontext save:nil];
//    return ;
//}
//
//
//
//
//-(NSArray *)finddatadingdong:(NSString *)stockcodeEx
//{
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"StockDD"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
//    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcodeEx=%@",stockcodeEx];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//
//    return arr;
//}
//

//
//
//
//-(void)deletestockDD:(NSString *)stockcodeEx
//{
//
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"StockDD"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
//    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcodeEx=%@",stockcodeEx];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    for (Stock *obj in arr)
//    {
//        [mangedcontext deleteObject:obj];
//    }
//    [mangedcontext save:nil];
//    return ;
//}
//
//-(void)deletestockDD
//{
//
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"StockDD"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
////    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcodeEx=%@",stockcodeEx];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    for (Stock *obj in arr)
//    {
//        [mangedcontext deleteObject:obj];
//    }
//    [mangedcontext save:nil];
//    return ;
//}
//
//
//-(void)deletestock
//{
//
//    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"Stock"];
//
//    //排序
//    //    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"stockcode" ascending:NO];
//    //    fetch.sortDescriptors=@[sort];
//    //加入查询条件 age>20
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"stockcodeEx=%@",stockcodeEx];
//
//    //    fetch.predicate=[NSPredicate predicateWithFormat:@"name like %@",@"*cb1*"];
//    NSArray *arr=[mangedcontext executeFetchRequest:fetch error:nil];
//    for (Stock *obj in arr)
//    {
//        [mangedcontext deleteObject:obj];
//    }
//    [mangedcontext save:nil];
//    return ;
//}


@end

