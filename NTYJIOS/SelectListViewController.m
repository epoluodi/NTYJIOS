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

@interface SelectListViewController ()

@end

@implementation SelectListViewController
@synthesize table,navbar;
@synthesize listtype;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    
    btnright = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ClickRight)];
    
    [btnreturn setTintColor :[UIColor whiteColor] ];
    [navbar.items[0] setLeftBarButtonItem:btnreturn];
    navbar.items[0].title=_titleCommon;
    
    
    if (listtype ==DEPARTMENT){
        dataarry = [[DBmanger getIntance] getDeparment];
        [navbar.items[0] setRightBarButtonItem:btnright];
    }
    
    
    table.backgroundColor=[UIColor clearColor];
    
    UINib *nib=[UINib nibWithNibName:@"selectlistcell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"cell"];
    
    table.delegate=self;
    table.dataSource=self;
    
    
    
    
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
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectListCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    Department *dep =dataarry[indexPath.row];
    cell.celltitle.text= dep.name;
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



-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ClickRight
{
  
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
