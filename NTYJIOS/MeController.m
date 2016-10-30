//
//  MeController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MeController.h"
#import "UserInfo.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "HttpServer.h"
#import <Common/PublicCommon.h>
#import "MainTabBarController.h"



@implementation MeController
@synthesize table,nickimg;


-(void)viewDidLoad
{
    isShow = NO;
    
    nickimg.layer.borderColor = [[UIColor whiteColor] CGColor];
    nickimg.layer.borderWidth=1;
    nickimg.layer.cornerRadius=6;
    nickimg.layer.masksToBounds=YES;
    nickimg.userInteractionEnabled=YES;
    
    nickimg.image= [UserInfo getInstance].nickimg;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(ClickNickImage)];
    [nickimg addGestureRecognizer:tap];
    
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor=[UIColor clearColor];
    // 判断当前是否有头像，没有需要下载
}


-(void)viewWillAppear:(BOOL)animated
{
    if (!isShow)
    {
        isShow=YES;
        [self initview];
    }
    [self reLoadUserInfo];
}
-(void)initview
{
    CGSize strsize = [[UserInfo getInstance].userName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    
    
    name=[[UILabel alloc] init];
    name.font =[UIFont boldSystemFontOfSize:22];
    name.textColor= [UIColor whiteColor];
    name.frame = CGRectMake(nickimg.frame.origin.x +nickimg.frame.size.width + 15,
                            nickimg.frame.origin.y +30, strsize.width, strsize.height);
    
    [self.view addSubview:name];
    
    
    strsize = [[UserInfo getInstance].positionName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    postname=[[UILabel alloc] init];
    postname.font =[UIFont boldSystemFontOfSize:16];
    postname.textColor= [UIColor whiteColor];
    
    postname.frame = CGRectMake(nickimg.frame.origin.x +nickimg.frame.size.width + 15 + name.frame.size.width +15,  name.frame.origin.y +(name.frame.size.height -strsize.height), strsize.width, strsize.height);
    
    [self.view addSubview:postname];
    
    strsize = [[UserInfo getInstance].deparmentname sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    departmentname=[[UILabel alloc] init];
    departmentname.font =[UIFont boldSystemFontOfSize:18];
    departmentname.textColor= [UIColor whiteColor];
    departmentname.frame = CGRectMake(nickimg.frame.origin.x +nickimg.frame.size.width + 15,
                                name.frame.origin.y +name.frame.size.height+10, strsize.width, strsize.height);
    
    [self.view addSubview:departmentname];
    
    
    
}

-(void)reLoadUserInfo
{
    name.text=[UserInfo getInstance].userName;
    postname.text=[UserInfo getInstance].positionName;
    departmentname.text = [UserInfo getInstance].deparmentname;
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(globalQ, ^{
        
        
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[UserInfo getInstance].picture]];
        
        
        __block NSData *jpgdata;
        
        if ([NSNull null] != [UserInfo getInstance].picture)
        {
            if (![filemanger fileExistsAtPath:_filename])
            {
                HttpServer *http = [[HttpServer alloc] init:DownloadUrl];
                jpgdata = [http FileDownload:[UserInfo getInstance].picture suffix:@"40" mediatype:@".jpg"];
                dispatch_async(mainQ, ^{
                    
                    if (jpgdata){
                        nickimg.image = [UIImage imageWithData:jpgdata];
                    }
                });
            }
            else
            {
                dispatch_async(mainQ, ^{
                    
                    jpgdata = [NSData dataWithContentsOfFile:_filename];
                    nickimg.image = [UIImage imageWithData:jpgdata];
                });
                
            }
        }
       
    });
}

//点击头像
-(void)ClickNickImage
{
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 pickerview = [[UIImagePickerController alloc] init];//初始化
                                 pickerview.delegate = self;
                                 pickerview.allowsEditing = YES;//设置可编辑
                                 UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                                 pickerview.sourceType = sourceType;
                                 [self presentModalViewController:pickerview animated:YES];//进入照相界面
                             }];
    
    
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                pickerview = [[UIImagePickerController alloc] init];//初始化
                                pickerview.delegate = self;
                                pickerview.allowsEditing = YES;//设置可编辑
                                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                pickerview.sourceType = sourceType;
                                [self presentModalViewController:pickerview animated:YES];//进入照相界面
                            }];
    
    
    
    
    [alert addAction:camera];
    [alert addAction:photo];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"SMILE!");
    //    [self.capturedImages addObject:image];
    
    //    if ([self.cameraTimer isValid])
    //    {
    //        return;
    //    }
    
    image = [PublicCommon scaleToSize:image size:CGSizeMake(512, 512)];
    
    
    NSData *jpgdata = UIImageJPEGRepresentation(image, 1);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [FileCommon getCacheDirectory];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",uuid];
    [fileManager createFileAtPath:[filePath stringByAppendingString:filename] contents:jpgdata attributes:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    MBProgressHUD *hub=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    [hub show:YES];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(globalQ, ^{
        
        HttpServer *http = [[HttpServer alloc] init:UploadUrl];
        ReturnData *rd =  [http uploadfile:jpgdata mediaid:uuid mediatype:@"01" filetype:@".jpg"];
        if (rd && rd.returnCode==0)
        {
            http = [[HttpServer alloc] init:UpdateUserNickImg];
            rd=   [http UpdateUserImg:uuid];
        }
        
        
        dispatch_async(mainQ, ^{
            [hub hide:YES];
            if (rd && rd.returnCode==0)
            {
                [UserInfo getInstance].nickimg =image;
                nickimg.image =     [UserInfo getInstance].nickimg;
                [UserInfo getInstance].picture = uuid;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        });
        
    });
    
    
    
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
            return Section1;
        case 1:
            return Section2;
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
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"setting1"];
                
                cell.textLabel.text=@"个人信息";
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"setting2"];
                cell.textLabel.text=@"密码设置";
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"setting3"];
                cell.textLabel.text=@"清除缓存";
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"setting4"];
                cell.textLabel.text=@"关于";
                break;
                
        }
    }
    if (indexPath.section==1)
    {
        cell.imageView.image = [UIImage imageNamed:@"setting5"];
        cell.textLabel.text=@"退出登录";
        
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"showuserinfo" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"showmodipwd" sender:nil];
                break;
            case 2:
                [self ClearCacheFile];
                break;
                
        }
    }
    if (indexPath.section==1)
    {
        [((MainTabBarController *)self.tabBarController) DisConnectMqtt];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.IsAutoLogin=NO;
        [self presentViewController:loginVC animated:YES completion:nil];
        
        return;
    }
}


//清除缓存
-(void)ClearCacheFile
{
    //显示loadview
    __block MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    [hub show:YES];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    
    NSString *path = [FileCommon getCacheDirectory];
    dispatch_async(globalQ, ^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        
        //清除文件缓存
        for (NSString *p in files) {
            NSError *error;
            NSString *filepath = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
            }
        }
        
        
        dispatch_async(mainQ, ^{
            [hub hide:YES];
            hub=nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        });
        
        
    });
    
    
    
}


#pragma mark -


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showuserinfo"])
    {
        UserInfoViewController *userinfvc = (UserInfoViewController*)[segue destinationViewController];
        userinfvc.IsSelf=YES;
        userinfvc.userid = [UserInfo getInstance].userId;
        return;
    }
}

@end
