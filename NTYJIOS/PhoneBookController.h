//
//  PhoneBookController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/13.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBmanger.h"
typedef   enum  {
    DEPARTMENTSORT,PYSORT
} PhoneSortEnum;


@interface PhoneBookController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
//    UINavigationItem *title;
    UIRefreshControl *refresh;
    UIBarButtonItem *btnright;
    __block PhoneSortEnum mode;
    
    BOOL isdisplay;
    //数据
    NSArray * group;
    NSArray * searchlist;
    
    NSMutableArray<NSString *>* pylist;
    NSMutableArray *groupdata;
    
    
    BOOL isSearch;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;

@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *table;



@end
