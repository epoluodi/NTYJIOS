//
//  UserInfoCell1.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "UserInfoCell1.h"

@implementation UserInfoCell1
@synthesize nickimg;
- (void)awakeFromNib {
    [super awakeFromNib];
    nickimg.layer.borderColor = [[UIColor grayColor] CGColor];
    nickimg.layer.borderWidth=1;
    nickimg.layer.cornerRadius=6;
    nickimg.layer.masksToBounds=YES;

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
