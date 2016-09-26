//
//  ChatTextLeftCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/26.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ChatTextLeftCell.h"

@implementation ChatTextLeftCell
@synthesize nickimg,content;
@synthesize labdt;
@synthesize contentH;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
   
    content.image = [[UIImage imageNamed:@"chat_left"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    contentH.constant=60;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
