//
//  ChatTextRightCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ChatTextRightCell.h"
#import <Common/PublicCommon.h>
@implementation ChatTextRightCell
@synthesize nickimg,content;
@synthesize labdt;
@synthesize contentH,contentmaginright;
@synthesize CellHight;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    content.image = [[UIImage imageNamed:@"chat_right"] stretchableImageWithLeftCapWidth:18 topCapHeight:38 ];
    
    labdt.backgroundColor = [UIColor clearColor];
    
    labcontent = [[UILabel alloc] init];
    labcontent.numberOfLines=0;
    labcontent.lineBreakMode = NSLineBreakByWordWrapping;
    CellHight=0;
    
    
    // Initialization code
}



-(void)setInfo:(NSString *)info dt:(NSString *)dt
{
    int w = [PublicCommon GetScreen].size.width - 40 -60-60;
    CGRect tmpRect = [info boundingRectWithSize:CGSizeMake(w, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    labcontent.font=[UIFont systemFontOfSize:16];
    contentmaginright.constant = [PublicCommon GetScreen].size.width -  tmpRect.size.width-10 -40-50 ;
    labcontent.frame = CGRectMake(20, 7, tmpRect.size.width, tmpRect.size.height+5);
    labcontent.textColor = [UIColor whiteColor];
    
    [content addSubview:labcontent];
    labcontent.text=info;
    if (tmpRect.size.height+20 < 45)
        contentH.constant=45;
    else
        contentH.constant=tmpRect.size.height+20;
    
    
    
    CellHight = tmpRect.size.height + 60;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
