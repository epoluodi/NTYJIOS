//
//  SelectListCell.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectListCell : UITableViewCell
{
    BOOL IsChk;
    
}

@property (weak,nonatomic) NSString *itemid;
@property (weak, nonatomic) IBOutlet UILabel *celltitle;
@property (weak, nonatomic) IBOutlet UIButton *chk;
@property (weak,nonatomic) UIViewController *delegateVC;

@end
