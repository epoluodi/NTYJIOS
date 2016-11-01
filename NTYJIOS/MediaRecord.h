//
//  MediaRecord.h
//  NTYJIOS
//
//  Created by Stereo on 16/9/1.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Common/FileCommon.h>




@protocol Recorddelegate

@optional
-(void)OnStartRecord;
-(void)OnStopRecord:(NSString *)filename;
-(void)OnCancelRecord;
-(void)OnPowerChange:(float)power;
-(void)OnPlayEnd;

@end
@interface MediaRecord : NSObject<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{

    AVAudioRecorder *audioRecorder;//音频录音机
    AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
    NSURL *pathurl;
    NSMutableDictionary *dicM;
    NSTimer *timer;
    NSString *filename;
    NSTimeInterval _duration;
}

@property (weak,nonatomic)NSObject<Recorddelegate> *delegate;
@property (assign)  NSTimeInterval recordduration;

-(BOOL)getRecordState;
-(BOOL)getPlayState;
-(instancetype)init;
-(instancetype)initAudio:(NSData *)audiodata;
-(BOOL)StartRecord;
-(void)StopRecord;
-(void)audioPlayer;
-(void)audioStop;

@end
