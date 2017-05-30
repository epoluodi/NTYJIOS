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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(clickchk)];
    [self.contentView addGestureRecognizer:tap];

    // Initialization code
}

-(void)setcheckbox:(BOOL)chkstate
{
    if (chkstate)
    {
        IsChk=YES;
        
        [chk setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
    }
    else
    {
        IsChk=NO;
        [chk setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
    
}
-(void)clickchk
{
    if (IsChk)
    {
        
        IsChk=NO;
        [chk setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [((SelectListViewController*)delegateVC) SelectGroupInfo:itemid name:[celltitle.text componentsSeparatedByString:@":"][0] isDel:NO];
        
    }
    else
    {
        IsChk=YES;
        [chk setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
        [((SelectListViewController*)delegateVC) SelectGroupInfo:itemid name:[celltitle.text componentsSeparatedByString:@":"][0] isDel:YES];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
 
    [super setSelected:selected animated:animated];
    

//        if (!selected)
//            return;
//
//    NSLog(@"%@,%D",itemid,selected);
//     [((SelectListViewController*)delegateVC) setchkBox:itemid cell:self];

    // Configure the view for the selected state
}

@end
