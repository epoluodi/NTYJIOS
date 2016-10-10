//
//  ChatLog+CoreDataClass.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatLog : NSManagedObject

@property (nullable, nonatomic, copy) NSString *groupid;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *msgid;
@property (nullable, nonatomic, copy) NSNumber *isself;
@property (nullable, nonatomic, copy) NSString *sender;
@property (nullable, nonatomic, copy) NSString *senderid;
@property (nullable, nonatomic, copy) NSNumber *msgType;
@property (nullable, nonatomic, copy) NSNumber *msgsendstate;
@property (nullable, nonatomic, copy) NSString *msgdate;


@end

NS_ASSUME_NONNULL_END


