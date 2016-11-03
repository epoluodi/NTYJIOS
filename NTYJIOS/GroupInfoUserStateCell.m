//
//  GroupInfoUserStateCell.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "GroupInfoUserStateCell.h"

@implementation GroupInfoUserStateCell
@synthesize userimg;
- (void)awakeFromNib {
    [super awakeFromNib];
    userimg.layer.cornerRadius = 6;
    userimg.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
