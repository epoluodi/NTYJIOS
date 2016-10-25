//
//  MessageViewContoller.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/20.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MessageViewContoller.h"
#import "FTPopOverMenu.h"
#import "HttpServer.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DBmanger.h"
#import "MessageCell.h"
#import <Common/PublicCommon.h>
#import "AppoverViewController.h"
#import "NotificationController.h"
#import "ChatViewController.h"
@interface MessageViewContoller ()
{
    AppDelegate *app;
}
@end

@implementation MessageViewContoller
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    app = [[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    
    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(Onright:)];
    btnright.tintColor = [UIColor whiteColor];
    
    btnleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"appover"] style:UIBarButtonItemStylePlain target:self action:@selector(Onleft)];
    btnleft.tintColor = [UIColor redColor];
    
    
    title = [[UINavigationItem alloc] initWithTitle:@"调度信息"];
    title.hidesBackButton=YES;
    
    
//    [title setLeftBarButtonItem:btnleft];
    [title setRightBarButtonItem:btnright];
    
    [self.navigationController.navigationBar pushNavigationItem:title animated:YES];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    table.dataSource=self;
    table.delegate=self;
    table.backgroundColor=[UIColor clearColor];
    
    UINib *nib=[UINib nibWithNibName:@"MessageCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    
    refreshcontrol = [[UIRefreshControl alloc] init];
    [refreshcontrol addTarget:self action:@selector(Onrefresh) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refreshcontrol];
    // Do any additional setup after loading the view.
}


//刷新
-(void)Onrefresh
{
    if (refreshcontrol.isRefreshing)
    {
        [self loadDDinfo];
    }
}



-(void)Onright:(id)sender
{
    
    
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                              withMenu:@[@"发布调度",@"历史调度",]
                        imageNameArray:@[@"publishjd",@"historyjd"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 
                                 switch (selectedIndex) {
                                     case 0://发布
                                         
                                         [self performSegueWithIdentifier:@"publish" sender:self];
                                         
                                         break;
                                     case 1:
                              
                                         break;
                                 }
                                 
                             } dismissBlock:^{
                                 
                                 NSLog(@"user canceled. do nothing.");
                                 
                             }];
}
-(void)Onleft
{
    [self performSegueWithIdentifier:@"showsh" sender:self];
}

-(void)loadDDinfo
{
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
       
        HttpServer *http =[[HttpServer alloc] init:queryGroupsAndDispatchs];
        BOOL result = [http getGroupsList];
        if (!result)
        {
            
            
            dispatch_async(mainQ, ^{
                if (refreshcontrol.refreshing)
                    [ refreshcontrol endRefreshing];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取调度信息失败，请重新登录!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                loginVC.mainview=(MainTabBarController *)self.tabBarController;
                [self presentViewController:loginVC animated:YES completion:nil];
                
            });
         
            
            return;
        }
        dispatch_async(mainQ, ^{
            if (refreshcontrol.refreshing)
                [ refreshcontrol endRefreshing];
            [self loadDDinfoFromDB];
        });
     
        
    });
  
    
}


-(void)loadDDinfoFromDB
{
    ddinfolist = [[DBmanger getIntance] getDDinfo];
    if (ddinfolist && ddinfolist.count >0)
        [table reloadData];
}
//加载数据
-(void)viewWillAppear:(BOOL)animated
{
    
    if ([UserInfo getInstance].Token){
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        
        
        dispatch_async(globalQ, ^{
            HttpServer *http = [[HttpServer alloc] init:queryDispatchMsgs];
            appoverlists = [[http getAppoverMsg] copy];
            
            dispatch_async(mainQ, ^{
                if (!appoverlists || [appoverlists count]==0)
                    [title setLeftBarButtonItem:nil];
                else
                    [title setLeftBarButtonItem:btnleft];
                
            });
            
        });
    }
    //查询一边需要审核的信息
    NSLog(@"显示");
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!ddinfolist)
        return 0;
    return [ddinfolist count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell* cell =[table dequeueReusableCellWithIdentifier:@"cell"];
    DDInfo *_ddinfo = ddinfolist[indexPath.row];
    cell.txttitle.text=_ddinfo.title;
    
    //    NSDateFormatter *dtformat = [[NSDateFormatter alloc] init];
    //    [dtformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"%@",_ddinfo.sendtime);
    cell.txtdt.text=[self dateTran:_ddinfo.sendtime];
    
    return cell;
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selectview = [[UIView alloc] init];
    selectview.frame = cell.contentView.frame;
    selectview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =selectview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        DDInfo *_ddinfo = ddinfolist[indexPath.row];
    [self performSegueWithIdentifier:@"showchat" sender:_ddinfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"showsh"])
     {
         AppoverViewController * appovervc = [segue destinationViewController];
         appovervc.appoverlist=appoverlists;
         return;
     }
     if ([segue.identifier isEqualToString:@"showchat"])
     {
         ChatViewController *chatvc =[segue destinationViewController];
         chatvc.ddinfo = ((DDInfo *)sender).ddid;
          chatvc.ddinfocreatedt = ((DDInfo *)sender).sendtime;
         return;
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
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
