//
//  DDInfo.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/22.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDInfo : NSManagedObject

@property (nullable, nonatomic, retain) NSString *ddid;
@property (nullable, nonatomic, retain) NSString *json;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *istop;
@property (nullable, nonatomic, retain) NSDate *sendtime;


// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

