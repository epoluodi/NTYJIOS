//
//  AppoverViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "AppoverViewController.h"
#import <Common/PublicCommon.h>
#import "JDDeltalViewController.h"


@interface AppoverViewController ()

@end

@implementation AppoverViewController
@synthesize table,navbar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    [navbar.items[0] setLeftBarButtonItem:btnreturn];
    navbar.items[0].title=@"消息审批";
    
    
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_appoverlist count];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *d = _appoverlist[indexPath.row];
    cell.textLabel.text=[d objectForKey:@"dispatch_title"];
    cell.detailTextLabel.text = [d objectForKey:@"dispatch_content"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
    NSDictionary *d = _appoverlist[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JDDeltalViewController *jddetailview= [storyboard instantiateViewControllerWithIdentifier:@"jddetail"];
    jddetailview.IsAppoverMode=YES;
    jddetailview.previousVC=self;
    jddetailview.info = d;
    [self presentViewController:jddetailview animated:YES completion:nil];
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
