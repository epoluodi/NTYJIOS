//
//  JDDeltalViewController.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaRecord.h"
@interface JDDeltalViewController : UIViewController<Recorddelegate>
{
    UIBarButtonItem *btnreturn;
    UIBarButtonItem *btnright;
    NSString *audioid;
    NSArray *pics;
    
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UIButton *btnaudio;
@property (weak, nonatomic) IBOutlet UILabel *info_title;
@property (weak, nonatomic) IBOutlet UIView *infoview;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UILabel *sendtime;
@property (weak, nonatomic) IBOutlet UIScrollView *infoscroll;
@property (assign) BOOL IsAppoverMode;

@property (weak,nonatomic)UIViewController *previousVC;

@property (weak,nonatomic)NSDictionary *info;

@property (weak, nonatomic) IBOutlet UILabel *groupinfo;




- (IBAction)ClickAudio:(id)sender;



@end
