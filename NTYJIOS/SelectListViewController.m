//
//  SelectListViewController.m
//  NTYJIOS
//
//  Created by Stereo on 16/9/2.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "SelectListViewController.h"
#import "DBmanger.h"
#import "SelectListCell.h"
#import "SelectListCell2.h"
#import "PublishViewController.h"
#import "HttpServer.h"
#import "MBProgressHUD.h"
#import <Common/FileCommon.h>

@interface SelectListViewController ()
{
       MBProgressHUD *hub;
}


@end

@implementation SelectListViewController
@synthesize table,navbar;
@synthesize listtype;
@synthesize delegateVC;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectnamelist = [[NSMutableArray alloc] init];
    selectidlist = [[NSMutableArray alloc] init];
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    
    btnright = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ClickRight)];
    
    [btnreturn setTintColor :[UIColor whiteColor] ];
    [btnright setTintColor :[UIColor whiteColor] ];
    [navbar.items[0] setLeftBarButtonItem:btnreturn];
    navbar.items[0].title=_titleCommon;
    
    table.backgroundColor=[UIColor clearColor];
    UINib *nib=[UINib nibWithNibName:@"selectlistcell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    
    nib=[UINib nibWithNibName:@"selectlistcell2" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell2"];
    
    
    if (listtype ==DEPARTMENT){
        dataarry = [[DBmanger getIntance] getDeparment];
        [navbar.items[0] setRightBarButtonItem:btnright];
        table.delegate=self;
        table.dataSource=self;
    }else if (listtype ==APPOVER)
    {
        hub = [[MBProgressHUD alloc] initWithView:table];
        [table addSubview:hub];
        [hub show:YES];
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(globalQ, ^{
            
            HttpServer *http =[[HttpServer alloc] init:queryApproveUsers];
            ReturnData *r  = [http queryApproveUserList];
            
            [NSThread sleepForTimeInterval:0.4];
            dispatch_async(mainQ, ^{
                [hub hide:YES];
                if (!r)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法加载审批人，请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return ;
                }
                dataarry = r.returnDatas;
             
                table.delegate=self;
                table.dataSource=self;
                [table reloadData];
            });
        });
        
        
    }
    

    
  
    
    
    
    
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [dataarry count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (listtype == DEPARTMENT)
        return 50;
    if (listtype == APPOVER)
        return 60;
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (listtype == DEPARTMENT){
        SelectListCell *cell1 = [table dequeueReusableCellWithIdentifier:@"cell"];

        cell1.delegateVC=self;
        Department *dep =dataarry[indexPath.row];
        cell1.celltitle.text= dep.name;
        cell1.itemid = dep.departmentid;
        return cell1;

    }
    if (listtype == APPOVER){
        SelectListCell2 *cell2 = [table dequeueReusableCellWithIdentifier:@"cell2"];
        
        cell2.delegateVC=self;
        NSDictionary *dict = dataarry[indexPath.row];
        Contacts *contacts = [[DBmanger getIntance] getContactswithuserId: [dict objectForKey:@"ACCOUNT_ID"]];
        
        cell2.celltitle.text= [dict objectForKey:@"USER_NAME"];
        cell2.cellsubtitle.text = contacts.positionname;
        
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",contacts.img]];
        
        if ([filemanger fileExistsAtPath:_filename])
        {
            NSData *jpgdata = [NSData dataWithContentsOfFile:_filename];
            cell2.nickimg.image = [UIImage imageWithData:jpgdata];
        }
     

        cell2.itemid = [dict objectForKey:@"ACCOUNT_ID"];
        return cell2;
        
    }
    return nil;
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
    if (listtype ==APPOVER)
    {
        NSDictionary *dict = dataarry[indexPath.row];
        [((PublishViewController *)delegateVC) SelectedAPPOVERInfo: [dict objectForKey:@"ACCOUNT_ID"] name: [dict objectForKey:@"USER_NAME"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ClickRight
{
    if (listtype == DEPARTMENT){
        [((PublishViewController *)delegateVC) SelectedSendInfo:[selectidlist componentsJoinedByString:@","]  name:[selectnamelist componentsJoinedByString:@","]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//选择
-(void)SelectGroupInfo:(NSString *)selectid name:(NSString *)name isDel:(BOOL)IsDel
{
    if (IsDel)
    {
        [selectidlist addObject:selectid];
        [selectnamelist addObject:name];
    }
    else{
        [selectidlist removeObject:selectid];
        [selectnamelist removeObject:name];
    }
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

@end
