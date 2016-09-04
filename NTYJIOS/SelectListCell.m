//
//  SelectListCell.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "SelectListCell.h"

@implementation SelectListCell
@synthesize chk,celltitle;
- (void)awakeFromNib {
    [super awakeFromNib];
    IsChk=NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!selected)
        return;
    if (IsChk)
    {
        IsChk=NO;
        [chk setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
    else
    {
        IsChk=YES;
        [chk setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
    }
    // Configure the view for the selected state
}

@end
