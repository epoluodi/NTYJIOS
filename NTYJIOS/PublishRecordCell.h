//
//  PublishRecordCell.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/31.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PublishRecordCell : UITableViewCell<AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecorder;//音频录音机
    AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
    NSURL *pathurl;
    NSMutableDictionary *dicM;
    NSTimer *timer;
}


@property (weak, nonatomic) IBOutlet UIButton *btncontrol;

@end
