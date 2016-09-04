//
//  SelectListViewController.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum :int
{
    DEPARTMENT,APPOVER,
} EnumListType;

@interface SelectListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem *btnreturn;
    UIBarButtonItem *btnright;
    NSArray * dataarry;
    
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic)NSString *titleCommon;
@property (assign)EnumListType listtype;

@end
