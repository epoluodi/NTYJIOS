//
//  ChatTextLeftCell.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/26.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTextLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *labdt;
@property (weak, nonatomic) IBOutlet UIImageView *nickimg;
@property (weak, nonatomic) IBOutlet UIImageView *content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentmaginright;


@end
