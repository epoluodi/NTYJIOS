//
//  PublishViewController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishRecordCell.h"

@interface PublishViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    UIBarButtonItem *btnreturn;
    UIBarButtonItem *btnsend;
    UILabel *wordcount;
    NSMutableArray<UIImageView *> * addedimage;
    NSMutableArray<NSString *> * mediaids;
    int words;
    UIButton *btnaddimage;
    UIImagePickerController *pickerview;
    BOOL IsAPPROVE;
    NSString *selectdepartmentlist,*selectdepartmentidlist;
    PublishRecordCell *cell1;
    
    
    NSString *approveruser,*approveruserid;
    NSString *recordfileid;
    
    
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITextField *edittitle;
@property (weak, nonatomic) IBOutlet UITextView *content;

@property (weak, nonatomic) IBOutlet UIScrollView *picturls;
@property (weak, nonatomic) IBOutlet UITableView *tablemenu;


-(void)SelectedSendInfo:(NSString *)itemid name:(NSString *)name;
-(void)SelectedAPPOVERInfo:(NSString *)itemid name:(NSString *)name;




@end
