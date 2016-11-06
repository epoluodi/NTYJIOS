//
//  HisCell.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/11/4.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *dditile;
@property (weak, nonatomic) IBOutlet UIImageView *ddimg;
@property (weak, nonatomic) IBOutlet UILabel *ddcontent;
@property (weak, nonatomic) IBOutlet UILabel *ddsender;
@property (weak, nonatomic) IBOutlet UILabel *ddsenddt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgwidth;



@end
