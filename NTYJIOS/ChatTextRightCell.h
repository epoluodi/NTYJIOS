//
//  ChatTextRightCell.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTextRightCell : UITableViewCell
{
       UILabel *labcontent;
      UILabel *_labdttxt;
}

@property (weak, nonatomic) IBOutlet UIView *labdt;
@property (weak, nonatomic) IBOutlet UIImageView *nickimg;
@property (weak, nonatomic) IBOutlet UIImageView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentmaginright;

@property (assign)NSUInteger CellHight;

-(void)setInfo:(NSString *)info dt:(NSString *)dt olddt:(NSString *)olddt;

-(void)setImgMsg:(NSString *)mediaid;
-(void)setInfodt:(NSString *)dt olddt:(NSString *)olddt;



@end
