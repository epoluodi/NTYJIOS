//
//  UserInfoViewController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell1.h"
#import "UserInfoCell2.h"


@implementation UserInfoViewController
@synthesize navbar,table;
@synthesize userid,IsSelf;
-(void)viewDidLoad
{
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    UINavigationItem *item = navbar.items[0];
    item.title=@"个人信息";
    [item setLeftBarButtonItem:btnreturn];
    table.backgroundColor = [UIColor clearColor];
    
    UINib *nib1= [UINib nibWithNibName:@"UserInfoCell" bundle:nil];
    UINib *nib2= [UINib nibWithNibName:@"UserInfoCell2" bundle:nil];
    [table registerNib:nib1 forCellReuseIdentifier:@"cell1"];
    [table registerNib:nib2 forCellReuseIdentifier:@"cell2"];
    
    table.dataSource = self;
    table.delegate=self;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark tabledelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 5;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v=[[UIView alloc] init];
    v.frame=cell.contentView.frame;
    v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =v;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.frame=CGRectMake(0, 0, table.frame.size.width, 10);
    return v;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 70;
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==1)
    {
        UserInfoCell2 *cell ;
        switch (indexPath.row) {
            case 0:
                 cell =[table dequeueReusableCellWithIdentifier:@"cell2"];
                cell.celltitile.text=@"姓名";
                cell.cellimg.image = [UIImage imageNamed:@"userinfo_2"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            case 1:
                cell =[table dequeueReusableCellWithIdentifier:@"cell2"];
                cell.celltitile.text=@"性别";
                cell.cellimg.image = [UIImage imageNamed:@"userinfo_3"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            case 2:
                cell =[table dequeueReusableCellWithIdentifier:@"cell2"];
                cell.celltitile.text=@"调度组";
                cell.cellimg.image = [UIImage imageNamed:@"userinfo_4"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            case 3:
                cell =[table dequeueReusableCellWithIdentifier:@"cell2"];
                cell.celltitile.text=@"职位";
                cell.cellimg.image = [UIImage imageNamed:@"userinfo_5"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            case 4:
                cell =[table dequeueReusableCellWithIdentifier:@"cell2"];
                cell.celltitile.text=@"手机号";
                cell.cellimg.image = [UIImage imageNamed:@"userinfo_6"];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
                
        }
        return cell;
    }
    if (indexPath.section==0)
    {
        UserInfoCell1 *cell = [table dequeueReusableCellWithIdentifier:@"cell1"];
        cell.celltitle.text = @"头像";
        cell.cellimg.image = [UIImage imageNamed:@"userinfo_1"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
      
                break;
            case 1:
          
                break;
                
        }
    }
}

#pragma mark -




@end
