//
//  MediaRecord.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/1.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MediaRecord.h"

@implementation MediaRecord
@synthesize delegate;


-(instancetype)init
{
    self = [super init];
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
    
    
    
    
    return self;
}

-(instancetype)initAudio:(NSData *)audiodata
{
    self = [super init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSError *error=nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:audiodata fileTypeHint:AVFileTypeWAVE error:&error];
    
    
//    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:urlStr] error:&error];
    NSLog(@"%@",error);
    
    audioPlayer.volume=1;
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    
    
    return self;
}

-(void)audioPowerChange
{
    [audioRecorder updateMeters];//更新测量值
    float power= [audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    NSLog(@"声波:%f",power);
    if (delegate)
        [delegate OnPowerChange:power];
    //    CGFloat progress=(1.0/160.0)*(power+160.0);
    
}





-(BOOL)StartRecord
{
    
    if (audioPlayer){
        [audioPlayer stop];
        audioPlayer=nil;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    if (!audioRecorder) {
        NSUUID *uuid = [NSUUID UUID];
        filename= uuid.UUIDString;
        NSString * urlStr=[[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",filename]];
        NSLog(@"file path:%@",urlStr);
        pathurl=[NSURL fileURLWithPath:urlStr];
        //创建录音机
        NSError *error=nil;
        
        audioRecorder=[[AVAudioRecorder alloc]initWithURL:pathurl settings:dicM error:&error];
        audioRecorder.delegate=self;
        audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return NO;
        }
    }
    if (audioRecorder.isRecording)
        [audioRecorder stop];
    if (delegate)
        [delegate OnStartRecord];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    
    
    return  [audioRecorder record];
    
    return NO;
}


-(void)StopRecord
{
    if (audioRecorder)
    {
        
        [timer invalidate];
        timer = nil;
        [audioRecorder stop];
    }
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (delegate)
        [delegate OnPlayEnd];
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    if (delegate)
        [delegate OnCancelRecord];
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    if (flag){
        if (delegate){
            NSString * urlStr=[[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",filename]];
            NSLog(@"file path:%@",urlStr);
            pathurl=[NSURL fileURLWithPath:urlStr];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            NSError *error=nil;
            audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:pathurl error:&error];

            audioPlayer.volume=1;
            audioPlayer.delegate = self;
            [audioPlayer prepareToPlay];
            NSLog(@"时间长 %f",audioPlayer.duration);
            
            if (error) {
                NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
                return;
            }
            
            
            [delegate OnStopRecord:filename];
        }
    }
    else{
        if (delegate)
            [delegate OnCancelRecord];
    }
    
    NSLog(@"录音完成!");
}


-(BOOL)getRecordState
{
    if (audioRecorder)
        return audioRecorder.isRecording;
    return NO;
}

-(BOOL)getPlayState
{
    if (audioPlayer)
        return  audioPlayer.isPlaying;
    return NO;
}

-(void)audioPlayer{
    
   if (audioPlayer)
   {
       [audioPlayer play];
   
   }
    
    return ;
}



-(void)audioStop
{
    if (audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer.currentTime=0;
    }
}

@end
