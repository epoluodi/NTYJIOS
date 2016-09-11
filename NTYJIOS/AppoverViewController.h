//
//  AppoverViewController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppoverViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem *btnreturn;

}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) NSArray *appoverlist;


@end
