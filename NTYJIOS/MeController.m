//
//  MeController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/7.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "MeController.h"
#import "UserInfo.h"
#import "UserInfoController.h"

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(ClickNickImage)];
    [nickimg addGestureRecognizer:tap];
    
    table.delegate=self;
    table.dataSource=self;
    table.backgroundColor=[UIColor clearColor];
    // 判断当前是否有头像，没有需要下载
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!isShow)
    {
        isShow=YES;
        [self initview];
    }
}
-(void)initview
{
    CGSize strsize = [[UserInfo getInstance].userName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];


    name=[[UILabel alloc] init];
    name.font =[UIFont boldSystemFontOfSize:22];
    name.textColor= [UIColor whiteColor];
    name.frame = CGRectMake(nickimg.frame.origin.x +nickimg.frame.size.width + 15,
                            nickimg.frame.origin.y +30, strsize.width, strsize.height);
    name.text=[UserInfo getInstance].userName;
    [self.view addSubview:name];
    
    strsize = [[UserInfo getInstance].positionName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    postname=[[UILabel alloc] init];
    postname.font =[UIFont boldSystemFontOfSize:18];
    postname.textColor= [UIColor whiteColor];
    postname.frame = CGRectMake(nickimg.frame.origin.x +nickimg.frame.size.width + 15,
                            name.frame.origin.y +name.frame.size.height+10, strsize.width, strsize.height);
    postname.text=[UserInfo getInstance].positionName;
    [self.view addSubview:postname];
    
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
    [UserInfo getInstance].nickimg =image;
    nickimg.image =     [UserInfo getInstance].nickimg;

    
    
    NSLog(@"SMILE!");
    //    [self.capturedImages addObject:image];
    
    //    if ([self.cameraTimer isValid])
    //    {
    //        return;
    //    }
    
    
    
    NSData *jpgdata = UIImageJPEGRepresentation(image, 80);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [FileCommon getCacheDirectory];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //
    NSString *filename = [NSString stringWithFormat:@"/%@.jpg",uuid];
    [fileManager createFileAtPath:[filePath stringByAppendingString:filename] contents:jpgdata attributes:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //    [self finishAndUpdate];
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
    v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.08];
    cell.selectedBackgroundView =v;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.frame=CGRectMake(0, 0, table.frame.size.width, 15);
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
    return 20;
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

        }
    }
}

#pragma mark -


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString:@"showuserinfo"])
        {
            UserInfoController *userinfvc = (UserInfoController*)[segue destinationViewController];
            userinfvc.IsSelf=YES;
            userinfvc.userid = [UserInfo getInstance].userId;
            return;
        }
}

@end
