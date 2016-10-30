//
//  RecordView.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/25.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"
#import "MediaRecord.h"


@protocol RecordViewdelegate

-(void)FinishRecord:(NSString *)filename duration:(int)duration;


@end
@interface RecordView : UIView<ControllDelegate,Recorddelegate>
{
    UIBlurEffect *blur;
    UIVisualEffectView *effectview;
    
    UIButton *btnclose;\
    RecordButton *btnrecord;
    UIImageView *recordstate;
    UILabel *lab;
    MediaRecord *media;
    NSString *_filename;
    BOOL isCacel;
   
}


@property (weak,nonatomic) NSObject<RecordViewdelegate> *delegate;
-(instancetype)init:(CGRect)frame;


@end
