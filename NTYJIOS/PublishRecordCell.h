//
//  PublishRecordCell.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/31.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaRecord.h"

@interface PublishRecordCell : UITableViewCell<Recorddelegate>
{
    MediaRecord *media;
    NSString *recordfilename;
}


@property (weak, nonatomic) IBOutlet UIButton *btncontrol;
@property (weak, nonatomic) IBOutlet UIButton *btnplay;

@property (weak, nonatomic) IBOutlet UIProgressView *powerprocess;


- (IBAction)ClickRecord:(id)sender;
- (IBAction)ClickPlayAndStop:(id)sender;

-(NSString *)getRecordFileName;

@end
