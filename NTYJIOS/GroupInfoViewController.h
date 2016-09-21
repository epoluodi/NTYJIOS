//
//  GroupInfoViewController.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>


@interface GroupInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __block NSArray *userlist;
}


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) NSString *ddid;
@property (assign) NSTimeInterval senddt;

@end
