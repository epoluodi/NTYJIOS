//
//  MessageCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/24.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize txtdt,txttitle;
@synthesize sender;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
