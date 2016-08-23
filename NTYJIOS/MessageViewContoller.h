//
//  MessageViewContoller.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewContoller : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UINavigationItem *title;
    UIBarButtonItem *btnleft;
    UIBarButtonItem *btnright;
    
    
}


@property (weak, nonatomic) IBOutlet UITableView *table;

-(void)loadDDinfo;
@end
