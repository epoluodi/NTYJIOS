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
    datadict = [[NSMutableDictionary alloc] init];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

-(void)Onright
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择显示类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"部门排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        mode=DEPARTMENTSORT;
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拼音排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        mode=DEPARTMENTSORT;
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
    group = [[DBmanger getIntance] getDeparment];
    NSLog(@"部门信息: %@",group);
    
    
}




#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (mode == DEPARTMENTSORT)
    {
        return group.count;
    }
    return 0;
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
