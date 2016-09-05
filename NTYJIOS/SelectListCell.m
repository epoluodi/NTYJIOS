//
//  SelectListCell.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "SelectListCell.h"
#import "SelectListViewController.h"

@implementation SelectListCell
@synthesize chk,celltitle;
@synthesize delegateVC;
@synthesize itemid;
- (void)awakeFromNib {
    [super awakeFromNib];
    IsChk=NO;
    [chk addTarget:self action:@selector(clickchk) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}


-(void)clickchk
{
    [self setSelected:YES animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!selected)
        return;
    if (IsChk)
    {
        IsChk=NO;
        [chk setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [((SelectListViewController*)delegateVC) SelectGroupInfo:itemid name:celltitle.text isDel:NO];
        
    }
    else
    {
        IsChk=YES;
        [chk setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
               [((SelectListViewController*)delegateVC) SelectGroupInfo:itemid name:celltitle.text isDel:YES];
    }
    // Configure the view for the selected state
}

@end
