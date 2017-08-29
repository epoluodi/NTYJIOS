//
//  GroupInfoViewController.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "HttpServer.h"
#import "MBProgressHUD.h"
#import "GroupInfoUserStateCell.h"
#import <Common/FileCommon.h>

@interface GroupInfoViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation GroupInfoViewController
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    table.backgroundColor = [UIColor clearColor];
    
    
    UINib *nib =[UINib nibWithNibName:@"userstatecell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    hud =[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    dispatch_async(globalQ, ^{
        
        HttpServer *http = [[HttpServer alloc] init:queryUsersByDispatchId];
        ReturnData *ret =[http queryDDInfowhituserState:_ddid];
 
        sleep(1);
        dispatch_async(mainQ, ^{
            [hud hide:YES];
            if (!ret)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取用户组信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            else{
                userlist = ret.returnDatas;
                NSLog(@"人员状态:%@",userlist);
                table.dataSource=self;
                table.delegate=self;
                [table reloadData];
            }
        });
        

    });
    
}


//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userlist count];
    
}
//
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoUserStateCell *cell =[table dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *d = userlist[indexPath.row];
    NSString *_nameex = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"USER_NAME"],[d objectForKey:@"POSITION_NAME"]];
    
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:15.0],NSFontAttributeName,
                                   [UIColor grayColor],NSForegroundColorAttributeName,nil];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_nameex];
    [AttributedStr addAttributes:attributeDict range:NSMakeRange(
                                                                 
                                                                 ((NSString *)[d objectForKey:@"USER_NAME"]).length+1,
                                                                 ((NSString *)[d objectForKey:@"POSITION_NAME"]).length)];
    cell.nameEx.attributedText = AttributedStr;
    
    cell.department.text=[d objectForKey:@"GROUP_NAMES"];
    
    
    
    
    if ([[d objectForKey:@"READ_STATUS"] isEqualToString:@"01"])
    {
        cell.stateimg.image = [UIImage imageNamed:@"ok_s"];
        
        NSString *timeStr = [d objectForKey:@"READ_TIME"];
        
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *d=[date dateFromString:timeStr];
        NSTimeInterval late=[d timeIntervalSince1970];
        NSTimeInterval cha=late - _senddt;
        if ((int)(cha  /60)  <0)
            cell.statedt.text = [NSString stringWithFormat: @"%d 分钟",1];
        else
            cell.statedt.text = [NSString stringWithFormat: @"%d 分钟",(int)(cha  /60)];
        
    }
    else
    {
        cell.stateimg.image = [UIImage imageNamed:@"no_s"];
        cell.statedt.text=@"0 分钟";
    }
    
    
    
    if ([d objectForKey:@"PICTURE"] != nil)
    {
        cell.userimg.contentMode=UIViewContentModeScaleAspectFit;
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[d objectForKey:@"PICTURE"]]];
        
        
        __block NSData *jpgdata;
        if ([filemanger fileExistsAtPath:_filename])
        {
            jpgdata = [NSData dataWithContentsOfFile:_filename];
            cell.userimg.image = [UIImage imageWithData:jpgdata];
        }
        else
            cell.userimg.image = [UIImage imageNamed:@"default_user"];
    }
    else
        cell.userimg.image = [UIImage imageNamed:@"default_user"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selectview = [[UIView alloc] init];
    selectview.frame = cell.contentView.frame;
    selectview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =selectview;
}
//


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

@end
