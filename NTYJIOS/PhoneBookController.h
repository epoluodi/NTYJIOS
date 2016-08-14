//
//  PhoneBookController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/13.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef   enum  {
    DEPARTMENTSORT,PYSORT
} PhoneSortEnum;


@interface PhoneBookController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UINavigationItem *title;
    UIRefreshControl *refresh;
    UIBarButtonItem *btnright;
    __block PhoneSortEnum mode;
}


@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *table;



@end
