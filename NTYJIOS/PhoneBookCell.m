//
//  PhoneBookCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/16.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "PhoneBookCell.h"

@implementation PhoneBookCell
@synthesize nickimg;
- (void)awakeFromNib {
    [super awakeFromNib];
    nickimg.layer.cornerRadius=6;
    nickimg.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
