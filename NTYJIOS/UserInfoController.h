//
//  UserInfoController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UIViewController
{
        UIBarButtonItem *btnreturn;
}

@property (copy,nonnull)NSString *userid;
@property (assign)BOOL IsSelf;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
