//
//  RecordView.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/25.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "RecordView.h"
#import "Common.h"
#import <Common/PublicCommon.h>

@implementation RecordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)init:(CGRect)frame
{
    self  = [super init];
     blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
     effectview = [[UIVisualEffectView alloc]initWithEffect:blur];
    
    effectview.frame = frame;

    self.frame = frame;
    media = [[MediaRecord alloc] init];
    media.delegate = self;
    isCacel = NO;
    [self addSubview:effectview];
    effectview.alpha=0.9f;
    self.userInteractionEnabled=YES;
    effectview.userInteractionEnabled=YES;
    btnclose = [[UIButton alloc] init];
    btnclose.userInteractionEnabled=YES;
    btnclose.frame = CGRectMake(frame.size.width  -60, 50, 40, 40);
 
    [btnclose setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(clickclose) forControlEvents:UIControlEventTouchUpInside];
    [effectview addSubview:btnclose];
    
    
    btnrecord = [[RecordButton alloc] init];

    btnrecord.frame =CGRectMake(frame.size.width/2 - 64/2, frame.size.height - 80,  64 , 64);
    
    btnrecord.layer.cornerRadius=64/2;
    btnrecord.layer.masksToBounds=YES;
    btnrecord.userInteractionEnabled=YES;
    btnrecord.layer.borderColor = [APPCOLOR CGColor];
    btnrecord.layer.borderWidth=0.9;
    
    [btnrecord setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    

    btnrecord.delegate=self;
    [btnrecord addTarget:self action:@selector(clickrecord) forControlEvents:UIControlEventTouchUpInside];
    [effectview addSubview:btnrecord];
    
    
    recordstate = [[UIImageView alloc] init];
    
    recordstate.image = nil;// [UIImage imageNamed:@"r3"];
    recordstate.frame =CGRectMake(frame.size.width/2 - 128/2, frame.size.height/2 - 128/2,  128 , 128);
    [effectview addSubview:recordstate];
    
    
    
    lab = [[UILabel alloc] init];
    lab.text = @"请按住录音，时间为60秒";
    lab.textColor  = [UIColor grayColor];
    lab.frame = CGRectMake(0, recordstate.frame.origin.y+128+20, frame.size.width, 50);
    lab.textAlignment = NSTextAlignmentCenter;
    [effectview addSubview:lab];
    return self;
}


-(void)OnStartRecord
{
    NSLog(@"录音开始");
}

-(void)OnCancelRecord
{
  
    NSLog(@"录音结束");
    [self removeFromSuperview];
}
-(void)OnPowerChange:(float)power
{
    CGFloat progress=(1.0/160.0)*(power+160.0);
  
    if (progress==0 && progress<0.2)
        recordstate.image = nil;
    else if (progress > 0.2 && progress<0.4)
         recordstate.image =[UIImage imageNamed:@"r1"];
    else if (progress > 0.4 && progress<0.7)
        recordstate.image =[UIImage imageNamed:@"r2"];
    else
        recordstate.image =[UIImage imageNamed:@"r3"];
    
    
    NSLog(@"音量 %f",progress);
}
-(void)OnStopRecord:(NSString *)filename
{
    [self removeFromSuperview];
    if (isCacel){
        return;
    }
    _filename = filename;
  
 
    [_delegate FinishRecord:_filename duration:(int)media.recordduration];
    NSLog(@"录音文件 %@",filename);
}





-(void)StartRecord
{
    isCacel = NO;
    NSLog(@"开始录音");
    [media StartRecord];
}

-(void)EndRecord
{
    
     NSLog(@"结束录音");
    [media StopRecord];
    
}

-(void)CancelRecord
{
    isCacel = YES;
    NSLog(@"取消录音");
    [media StopRecord];
}

-(void)clickrecord
{
    
}

-(void)clickclose
{
    [self removeFromSuperview];
}
@end
