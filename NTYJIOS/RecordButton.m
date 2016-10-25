//
//  RecordButton.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/10/25.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "RecordButton.h"

@implementation RecordButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init:(UIView *)view
{
    
    self = [super init];
    _view = view;
    isCancel = NO;
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_delegate StartRecord];
    isCancel = YES;
    self.highlighted=YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.highlighted=NO;
    if (!isCancel){
 
        return;
    }

    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch  locationInView:_view];
    
 
    if ((point.x <self.frame.origin.x ||
        point.x > (self.frame.origin.x + self.frame.size.width))
        || (
        
        point.y < self.frame.origin.y ||
        point.y > self.frame.origin.y + self.frame.size.height
        ))
    {
        isCancel=NO;
        [_delegate CancelRecord];
    }
    else
    {
        [_delegate EndRecord];
    }
    
    
 
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isCancel){
        self.highlighted=NO;
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch  locationInView:_view];
    
    if ((point.x <self.frame.origin.x ||
         point.x > (self.frame.origin.x + self.frame.size.width))
        || (
            
            point.y < self.frame.origin.y ||
            point.y > self.frame.origin.y + self.frame.size.height
            ))
    {
              isCancel=NO;
        [_delegate CancelRecord];
    }
    
    
    NSLog(@"移动，%@", NSStringFromCGPoint(point));
}
@end
