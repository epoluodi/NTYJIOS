//
//  SelectListCell2.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/5.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectListCell2 : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *nickimg;
@property (weak, nonatomic) IBOutlet UILabel *celltitle;
@property (weak, nonatomic) IBOutlet UILabel *cellsubtitle;
@property (weak,nonatomic) NSString *itemid;


@property (weak,nonatomic) UIViewController *delegateVC;


@end
