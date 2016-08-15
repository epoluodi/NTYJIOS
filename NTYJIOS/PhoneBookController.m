//
//  PhoneBookController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/13.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "PhoneBookController.h"
#import <Common/PublicCommon.h>
#import "HttpServer.h"

@interface PhoneBookController ()

@end

@implementation PhoneBookController
@synthesize search,table;
- (void)viewDidLoad {
    [super viewDidLoad];
    search.placeholder=@"关键字:联系人/电话";
    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(Onright)];
    btnright.tintColor = [UIColor whiteColor];
    title = [[UINavigationItem alloc] initWithTitle:@"通讯录"];
    title.hidesBackButton=YES;
    
    [title setRightBarButtonItem:btnright];
    [self.navigationController.navigationBar pushNavigationItem:title animated:YES];
    search.inputAccessoryView =[PublicCommon getInputToolbar:self sel:@selector(CloseInput)];
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    [table setBackgroundColor:[UIColor clearColor]];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(Onrefresh) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refresh];
    
    mode=DEPARTMENTSORT;
    
    groupdata = [[NSMutableArray alloc] init];
    table.delegate=self;
    table.dataSource=self;
    [self loadData];
    
    
    // Do any additional setup after loading the view.
}

-(void)Onright
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择显示类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"部门排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        mode=DEPARTMENTSORT;
        [self loadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拼音排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        mode=DEPARTMENTSORT;
        [self loadData];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//刷新
-(void)Onrefresh
{
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (refresh.isRefreshing)
    {
        dispatch_async(globalQ, ^{
            
            HttpServer *http =[[HttpServer alloc] init:queryGroups];
            BOOL result = [http getdepartmentinfo];
            if (!result)
            {
                [self finshRefresh:NO];
                return;
            }
            http =[[HttpServer alloc] init:queryUsers];
            result = [http getdepartmentUserinfo];
            if (!result)
            {
                [self finshRefresh:NO];
                return;
            }
            [self loadData];
            [self finshRefresh:YES];
        });
        
    }
}


-(void)finshRefresh:(BOOL)r
{
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(mainQ, ^{
        
        [refresh endRefreshing];
        
    });
}
-(void)CloseInput
{
    [search resignFirstResponder];
    
}



// 加载用户信息
-(void)loadData
{
    if (mode ==DEPARTMENTSORT){
        
        group = [[DBmanger getIntance] getDeparment];
        NSLog(@"部门信息: %@",group);
        [groupdata removeAllObjects];
        for (Department *depart in group) {
            NSLog(@"调度组名称: %@",depart.name);
            NSArray *contacts = [[DBmanger getIntance] getContactswithDepartment:depart.departmentid];
            
            [groupdata addObject:contacts];
        }
    }else if (mode == PYSORT){
    
        
    
    }
    [table beginUpdates];
    [table reloadData];
    [table endUpdates];
}




#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (!group)
        return 0;
    return group.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)groupdata[section]).count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return group[section].name;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selectview = [[UIView alloc] init];
    selectview.frame = cell.contentView.frame;
    selectview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =selectview;
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
    Contacts*contacts =  ((NSArray *)groupdata[indexPath.section])[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image = [UIImage imageNamed:@"default_avatar"];
    cell.textLabel.text = contacts.name;
    cell.imageView.hidden=NO;
    
    return cell;
}

#pragma mark -

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
