//
//  HistoryViewController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/11/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPopOverMenu.h"



@interface HistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
     UIBarButtonItem *btnright;
}


@property (weak, nonatomic) IBOutlet UITableView *table;

@end
