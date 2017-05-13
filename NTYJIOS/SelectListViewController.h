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
    NSMutableArray<NSString *>* selectnamelist;
    NSMutableArray<NSString *>* selectidlist;
    
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic)NSString *titleCommon;
@property (assign)EnumListType listtype;
@property (weak,nonatomic)UIViewController *delegateVC;
@property (weak,nonatomic)NSString *selectedlist;
@property (weak,nonatomic)NSString *selectednamelist;

-(void)SelectGroupInfo:(NSString *)selectid name:(NSString *)name isDel:(BOOL)IsDel;
@end
