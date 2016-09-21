//
//  GroupInfoUserStateCell.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupInfoUserStateCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *stateimg;

@property (weak, nonatomic) IBOutlet UILabel *statedt;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *nameEx;

@property (weak, nonatomic) IBOutlet UIImageView *userimg;


@end
