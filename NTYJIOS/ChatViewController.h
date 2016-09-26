//
//  ChatViewController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/16.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInfo.h"

@interface ChatViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,
UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem *btnright;
    UINavigationItem *itemtitle;
    NSDictionary *ddinfodict;
    
    NSMutableArray *chatlists;
    
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UILabel *infotitle;
@property (weak, nonatomic) IBOutlet UILabel *infodt;

@property (weak, nonatomic) IBOutlet UIImageView *infoimg;
@property (weak, nonatomic) IBOutlet UILabel *infocontent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cotentH;
@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputautoH;
@property (weak, nonatomic) IBOutlet UITextField *chatcontent;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)clicksend:(id)sender;

@property (weak,nonatomic) DDInfo *ddinfo;

@end
