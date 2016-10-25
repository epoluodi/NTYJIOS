//
//  RecordButton.h
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/25.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ControllDelegate

-(void)StartRecord;
-(void)CancelRecord;
-(void)EndRecord;
@end

@interface RecordButton : UIButton
{
    UIView *_view;
    BOOL isCancel;
}

@property (weak,nonatomic)NSObject<ControllDelegate> *delegate;

-(instancetype)init:(UIView *)view;

@end
