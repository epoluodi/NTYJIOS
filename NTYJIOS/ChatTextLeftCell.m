//
//  ChatTextLeftCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/26.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ChatTextLeftCell.h"
#import <Common/PublicCommon.h>

@implementation ChatTextLeftCell
@synthesize nickimg,content;
@synthesize labdt;
@synthesize contentH,contentmaginright;
@synthesize CellHight;
@synthesize sendname;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    content.image = [[UIImage imageNamed:@"chat_left"] stretchableImageWithLeftCapWidth:18 topCapHeight:38 ];
    
    labdt.backgroundColor = [UIColor clearColor];
    
    
    labcontent = [[UILabel alloc] init];
    labcontent.numberOfLines=0;
    labcontent.lineBreakMode = NSLineBreakByWordWrapping;
    CellHight=0;
    
    _labdttxt = [[UILabel alloc] init];
    _labdttxt.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    _labdttxt.layer.cornerRadius=4;
    _labdttxt.layer.masksToBounds=YES;
    _labdttxt.textColor=[UIColor whiteColor];
    _labdttxt.font = [UIFont systemFontOfSize:12];
    _labdttxt.textAlignment = NSTextAlignmentCenter;
    
    
    // Initialization code
}

-(void)setInfo:(NSString *)info dt:(NSString *)dt olddt:(NSString *)olddt
{
    NSDateFormatter *dtformat = [[NSDateFormatter alloc] init];
    [dtformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *_olddt = [dtformat dateFromString:olddt];
    NSDate *_nowdt = [dtformat dateFromString:dt];
    
    
    if (olddt)
    {
        
        
        
        NSTimeInterval time = [_nowdt timeIntervalSinceDate:_olddt];
        if (time > 60)
        {
      
          [_labdttxt removeFromSuperview];
            NSString *trandt =[PublicCommon dateTran:_nowdt];
            CGSize size = [trandt sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
            _labdttxt.text = [PublicCommon dateTran:_nowdt];
            [labdt addSubview:_labdttxt];
            _labdttxt.frame = CGRectMake([PublicCommon GetALLScreen].size.width /2 -(size.width+8)/2 , 2, size.width+8, size.height+3);
        }
        
        
        
    }else
    {
        
        NSString *trandt =[PublicCommon dateTran:_nowdt];
        CGSize size = [trandt sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
        _labdttxt.text = [PublicCommon dateTran:_nowdt];
        [_labdttxt removeFromSuperview];
        [labdt addSubview:_labdttxt];
        _labdttxt.frame = CGRectMake([PublicCommon GetALLScreen].size.width /2 -(size.width+8)/2 , 1, size.width+8, size.height+3);
    }
    
    
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
    
    
    
    CellHight = tmpRect.size.height + 60 +10;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
