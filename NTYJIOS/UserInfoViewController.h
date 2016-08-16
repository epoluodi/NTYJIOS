//
//  UserInfoViewController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBmanger.h"

@interface UserInfoViewController : UIViewController
{
    UIBarButtonItem *btnreturn;
}

@property (copy,nonatomic)NSString *userid;
@property (assign) BOOL IsSelf;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic)Contacts *contacts;

@end
