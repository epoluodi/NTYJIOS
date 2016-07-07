//
//  MeController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Section1 4
#define Section2 1

@interface MeController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *name,*postname;
    BOOL isShow;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *nickimg;


@end
