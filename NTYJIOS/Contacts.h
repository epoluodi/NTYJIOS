//
//  Contacts.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/13.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contacts : NSManagedObject
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *loginname;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) NSString *tel;
@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSString *groupid;
@property (nullable, nonatomic, retain) NSString *groupname;
@property (nullable, nonatomic, retain) NSString *py;
@property (nullable, nonatomic, retain) NSString *positionid;
@property (nullable, nonatomic, retain) NSString *positionname;
@property (nullable, nonatomic, retain) NSString *firstLetter;
// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END


