//
//  RecordView.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/25.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"

@interface RecordView : UIView<ControllDelegate>
{
    UIBlurEffect *blur;
    UIVisualEffectView *effectview;
    
    UIButton *btnclose;\
    RecordButton *btnrecord;
    UIImageView *recordstate;
    UILabel *lab;
    
}

-(instancetype)init:(CGRect)frame;

@end
