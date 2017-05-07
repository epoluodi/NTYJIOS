//
//  HistoryViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/11/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "HistoryViewController.h"
#import <Common/PublicCommon.h>
#import "MBProgressHUD.h"
#import "HttpServer.h"
#import "HisCell.h"
#import <Common/FileCommon.h>
#import "JDDeltalViewController.h"


@interface HistoryViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation HistoryViewController
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(Onright:)];
    btnright.tintColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    table.backgroundColor = [UIColor clearColor];
    
    jsondata = [[NSArray alloc] init];
    //    [title setLeftBarButtonItem:btnleft];
    [self.navigationItem setRightBarButtonItem:btnright];
    self.tabBarController.tabBar.hidden=YES;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self getHisoryData:@"01"];
    
    UINib *nib = [UINib nibWithNibName:@"hiscell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    table.delegate=self;
    table.dataSource = self;
    
    // Do any additional setup after loading the view.
}


-(void)getHisoryData:(NSString *)timetype
{
    [self.view addSubview:hud];
    [hud show:YES];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
       
        HttpServer *http = [[HttpServer alloc] init:queryHisDispatchMsgs];
       ReturnData *rd =  [http queryHistoryJD:timetype];
        dispatch_async(mainQ, ^{
            [hud hide:YES];
            if (!rd)
            {
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取历史信息失败!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            
            jsondata = rd.returnDatas;
            [table reloadData];
            NSLog(@"历史数据 %@",jsondata);
            
            
        });
        
    });
    
}





-(void)Onright:(id)sender
{
    
    
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                              withMenu:@[@"一个月内",@"三个月内",@"一年内"]
                        imageNameArray:@[@"month",@"month3",@"year"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 
                                 switch (selectedIndex) {
                                     case 0://发布
                                         [self getHisoryData:@"01"];
                                         
                                         break;
                                     case 1:
                                         [self getHisoryData:@"02"];
                                         break;
                                     case 2:
                                         [self getHisoryData:@"03"];
                                         break;
                                 }
                                 
                             } dismissBlock:^{
                                 
                                 NSLog(@"user canceled. do nothing.");
                                 
                             }];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsondata count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HisCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    
    
    NSDictionary *dict = jsondata[indexPath.row];
    cell.dditile.text = [dict objectForKey:@"DISPATCH_TITLE"];
    cell.ddcontent.text = [dict objectForKey:@"DISPATCH_CONTENT"];
    cell.ddsender.text =[NSString stringWithFormat:@"发布人：%@",[dict objectForKey:@"USER_NAME"] ];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt = [df dateFromString:[dict objectForKey:@"SEND_TIME"]];
    cell.ddsenddt.text =[NSString stringWithFormat:@"%@",[self dateTran:dt] ];
    if ([[dict objectForKey:@"PIC_IDS"] isEqualToString:@""])
    {
        cell.imgwidth.constant=0;
    }
    else
    {
        NSArray *imgs = [[dict objectForKey:@"PIC_IDS"] componentsSeparatedByString:@","];
        NSString *mediaid = imgs[0];
        [self DownloadImg:mediaid imgview:cell.ddimg];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict = jsondata[indexPath.row];
    
    NSDictionary *ddinfo = [[NSDictionary alloc] initWithObjectsAndKeys:
        [dict objectForKey:@"DISPATCH_TITLE"],@"dispatch_title",
    [dict objectForKey:@"USER_NAME"],@"send_user_name",
      [dict objectForKey:@"SEND_TIME"],@"create_time",
    [dict objectForKey:@"AUDIO_ID"],@"audio_id",
    [dict objectForKey:@"PIC_IDS"],@"pic_ids",
    [dict objectForKey:@"PIC_IDS"],@"pic_ids",
    [dict objectForKey:@"DISPATCH_CONTENT"],@"dispatch_content",
    
    nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JDDeltalViewController *jddetailview= [storyboard instantiateViewControllerWithIdentifier:@"jddetail"];
    jddetailview.IsAppoverMode=NO;
    jddetailview.previousVC=self;
    jddetailview.info = ddinfo;
    [self presentViewController:jddetailview animated:YES completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selectview = [[UIView alloc] init];
    selectview.frame = cell.contentView.frame;
    selectview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =selectview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)DownloadImg:(NSString *)mediaid imgview:(UIImageView *)imgview
{
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(globalQ, ^{
        
        
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",mediaid]];
        
        
        __block NSData *jpgdata;
        if (![filemanger fileExistsAtPath:_filename])
        {
            HttpServer *http = [[HttpServer alloc] init:DownloadUrl];
            jpgdata = [http FileDownload:mediaid suffix:@"aumb" mediatype:@".jpg"];
            dispatch_async(mainQ, ^{
                
                if (jpgdata){
                    imgview.image = [UIImage imageWithData:jpgdata];
                }
            });
        }
        else
        {
            dispatch_async(mainQ, ^{
                jpgdata = [NSData dataWithContentsOfFile:_filename];
                imgview.image = [UIImage imageWithData:jpgdata];
            });
            
        }
    });
}





-(NSString *)dateTran:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *compsnow = [[NSDateComponents alloc] init];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    compsnow = [calendar components:unitFlags fromDate:now];
    comps = [calendar components:unitFlags fromDate:date];
    
    if (comps.month==compsnow.month &&
        comps.day == compsnow.day)
    {
        df.dateFormat  = @"今天 HH:mm:ss";
        return [df stringFromDate:date];
    }
    else
    {
        df.dateFormat  = @"MM-dd HH:mm:ss";
        return [df stringFromDate:date];
    }
    
}



@end
