//
//  MeController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MeController.h"

@implementation MeController
@synthesize table,nickimg;


-(void)viewDidLoad
{
    isShow = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!isShow)
    {
        isShow=YES;
        [self initview];
    }
}
-(void)initview
{
    
    name=[[UILabel alloc] init];
    name.frame = CGRectMake(0, 0, 0, 0);
    
}


#pragma mark tabledelegate


#pragma mark -


@end
