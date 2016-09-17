//
//  NotificationController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/15.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "NotificationController.h"

@implementation NotificationController


+(void)sendNotification:(NSString *)content
{
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
    // 2.2.设置通知的内容
    localNote.alertBody = content;
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
//    localNote.alertAction = @"解锁";
    // 2.4.决定alertAction是否生效
//    localNote.hasAction = YES;
    // 2.5.设置点击通知的启动图片
    localNote.alertLaunchImage = @"logo";
    // 2.6.设置alertTitle
//    localNote.alertTitle = @"你有一条新通知";
    // 2.7.设置有通知时的音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 1;
    
    // 2.9.设置额外信息
//    localNote.userInfo = @{@"type" : @1};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
@end
