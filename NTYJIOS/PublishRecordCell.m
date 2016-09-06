//
//  PublishRecordCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/31.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "PublishRecordCell.h"





@implementation PublishRecordCell
@synthesize powerprocess,btnplay,btncontrol;

- (void)awakeFromNib {
    [super awakeFromNib];
    powerprocess.hidden=YES;
    btnplay.hidden=YES;
    media = [[MediaRecord alloc] init];
    media.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (IBAction)ClickRecord:(id)sender {
    if ([media getRecordState]){
        powerprocess.hidden=YES;
        [media StopRecord];
        [ btncontrol setBackgroundImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
    }
    else{
        btnplay.hidden=NO;
        powerprocess.hidden=NO;
        [media StartRecord];
          [ btncontrol setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
}

- (IBAction)ClickPlayAndStop:(id)sender {
    if ([media getPlayState]){
        [media audioStop];
           [ btnplay setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else{
        [media audioPlayer];
               [ btnplay setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    
}

-(void)OnStartRecord
{
    NSLog(@"录音开始");
}

-(void)OnCancelRecord
{
        NSLog(@"录音结束");
    powerprocess.hidden=YES;
    btnplay.hidden=YES;
    [ btncontrol setBackgroundImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
}
-(void)OnPowerChange:(float)power
{
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [powerprocess setProgress:progress animated:YES];
}
-(void)OnStopRecord:(NSString *)filename
{
    [ btncontrol setBackgroundImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
    recordfilename = filename;
    NSLog(@"录音文件 %@",filename);
}
-(void)OnPlayEnd
{
    [ btnplay setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}
-(NSString *)getRecordFileName
{
    return recordfilename;
}
@end
