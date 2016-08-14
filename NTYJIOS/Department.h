//
//  Department.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/13.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Department : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *departmentid;


@end

NS_ASSUME_NONNULL_END

