//
//  PublishRecordCell.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/31.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "PublishRecordCell.h"

#import <Common/FileCommon.h>
#define kRecordAudioFile @"myRecord.aac"


@implementation PublishRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)initRecordSession
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    

    NSString * urlStr=[[FileCommon getCacheDirectory] stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    pathurl=[NSURL fileURLWithPath:urlStr];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
}


-(void)audioPowerChange
{
    [audioRecorder updateMeters];//更新测量值
    float power= [audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    NSLog(@"声波:%f",power);
//    CGFloat progress=(1.0/160.0)*(power+160.0);
//    [self.audioPower setProgress:progress];
}



/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(void)audioRecorder{
    if (!audioRecorder) {
  
        //创建录音机
        NSError *error=nil;
        audioRecorder=[[AVAudioRecorder alloc]initWithURL:pathurl settings:dicM error:&error];
        audioRecorder.delegate=self;
        audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
    }
    return;
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
//    if (![audioPlayer isPlaying]) {
//        [audioPlayer play];
//    }
    NSLog(@"录音完成!");
}


@end
