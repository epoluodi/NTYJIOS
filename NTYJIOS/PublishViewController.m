//
//  PublishViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/8/21.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "PublishViewController.h"
#import <Common/PublicCommon.h>
#import <Common/FileCommon.h>
#import "UserInfo.h"
#import "PublishRecordCell.h"
#import "PublishCell.h"
#import "SelectListViewController.h"
#import "HttpServer.h"
#import "MBProgressHUD.h"
#import <Common/FileCommon.h>

@interface PublishViewController ()
{
    MBProgressHUD  *hub;
}
@end

@implementation PublishViewController
@synthesize tablemenu,picturls,content,edittitle;
@synthesize navbar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    
    btnsend = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(Clicksend)];
    [btnsend setTintColor :[UIColor whiteColor] ];
    
    
    [navbar.items[0] setLeftBarButtonItem:btnreturn];
    [navbar.items[0] setRightBarButtonItem:btnsend];
    
    wordcount = [[UILabel alloc] init];
    
    wordcount.frame=CGRectMake([PublicCommon GetScreen].size.width - 110, 216-30, 100, 25);
    wordcount.font=[UIFont systemFontOfSize:14];
    wordcount.textAlignment= NSTextAlignmentRight;
    wordcount.text=@"0/800 字";
    wordcount.textColor=[[UIColor grayColor] colorWithAlphaComponent:0.5];
    [content addSubview:wordcount];
    content.delegate = self;
    content.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    edittitle.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    addedimage = [[NSMutableArray alloc] init];
    mediaids = [[NSMutableArray alloc] init];
    btnaddimage = [[UIButton alloc] init];
    btnaddimage.frame=CGRectMake(3, 3, 98, 71);
    btnaddimage.userInteractionEnabled=YES;
    [btnaddimage setImage:[UIImage imageNamed:@"aay"] forState:UIControlStateNormal];
    picturls.backgroundColor=[UIColor whiteColor];
    picturls.pagingEnabled=NO;
    picturls.bounces=YES;
    picturls.scrollEnabled=YES;
    picturls.showsVerticalScrollIndicator=NO;
    picturls.alwaysBounceHorizontal=NO;
    picturls.showsHorizontalScrollIndicator=NO;
    picturls.alwaysBounceVertical=NO;
    picturls.contentSize = CGSizeMake([ PublicCommon GetScreen].size.width,0);
    picturls.userInteractionEnabled=YES;
    [picturls  addSubview:btnaddimage];
    [btnaddimage  addTarget:self action:@selector(ClickAddImage) forControlEvents:UIControlEventTouchUpInside];
    IsAPPROVE =NO;
    [self initTable];
    // Do any additional setup after loading the view.
}

-(void)textViewDidChange:(UITextView *)textView
{
    words = (int)textView.text.length;
    wordcount.text= [NSString stringWithFormat:@"%03d 字",words];
   
}

//添加图片
-(void)ClickAddImage
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    NSData *jpgdata = UIImageJPEGRepresentation(image, 1);
    if (jpgdata.length >500 *1024 )
    {
        UIImage *tmpimg = [UIImage imageWithData:jpgdata scale:0.4];
        jpgdata=UIImageJPEGRepresentation(tmpimg, 0.8);

    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [FileCommon getCacheDirectory];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //
    NSString *filename = [NSString stringWithFormat:@"/%@.jpg",uuid];
    [fileManager createFileAtPath:[filePath stringByAppendingString:filename] contents:jpgdata attributes:nil];
    
    
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.userInteractionEnabled=YES;
    imgview.image = image;
    imgview.contentMode=UIViewContentModeScaleAspectFill;
    imgview.frame=CGRectMake(3 +
                             ([mediaids count] * 98) +
                             ([mediaids count] * 3),
                             3, 98, 71);
    
    [picturls addSubview:imgview];
    imgview.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    imgview.layer.borderWidth=1;
    imgview.layer.masksToBounds=YES;
    
    [mediaids addObject:uuid];
    [addedimage addObject:imgview];
    btnaddimage.frame=CGRectMake(3 +
                                 ([mediaids count] * 98) +
                                 ([mediaids count] * 3), 3, 98, 71);
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    [imgview addGestureRecognizer:longpress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)];
    tap.numberOfTapsRequired=1;
    [imgview addGestureRecognizer:tap];
    
    
}

- (void) TapAction:(UILongPressGestureRecognizer *)longpressGetture
{
    NSLog(@"Tap pressTap state :begin");
}
- (void) longTapAction:(UILongPressGestureRecognizer *)longpressGetture {
    
    
    
    if (longpressGetture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long pressTap state :begin");
    }else {
        NSLog(@"long pressTap state :end");
        UIImageView *imgview = (UIImageView *)longpressGetture.view;
        uint index = (uint)[addedimage indexOfObject:imgview];
        if (![addedimage containsObject:imgview])
            return;
        [mediaids removeObjectAtIndex:index];
        [addedimage removeObject:imgview];
        [imgview removeFromSuperview];
        __block int i = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView animateWithDuration:0.4f animations:^{
            for (UIImageView *_imgview in addedimage) {
                
                _imgview.frame=CGRectMake(3 +
                                          (i * 98) +
                                          (i* 3), 3, 98, 71);
                i++;
            }
            btnaddimage.frame =CGRectMake(3+ (i * 98) +
                                          (i* 3), 3, 98, 71);
        }];
        
        [UIView commitAnimations];
        
   
        
        
        
        
    }
    
}
-(void)initTable
{
    if ([[UserInfo getInstance].auth containsObject:@"DISPATCH_APPROVE"])
        IsAPPROVE =YES;
    else
        IsAPPROVE = NO;
    
    UINib *nib = [UINib nibWithNibName:@"publishrecordcell" bundle:nil];
    [tablemenu registerNib:nib forCellReuseIdentifier:@"cell1"];
    nib = [UINib nibWithNibName:@"publishcell" bundle:nil];
    [tablemenu registerNib:nib forCellReuseIdentifier:@"cell2"];
    tablemenu.backgroundColor=[UIColor clearColor];
    tablemenu.delegate=self;
    tablemenu.dataSource=self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    if (indexPath.section==0)
    {
        selectview.backgroundColor=[UIColor clearColor];
    }
    else
        selectview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.03];
    cell.selectedBackgroundView =selectview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
            
        case 1:
            
            return 10;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0)
        return 1;
    else if (section ==1)
    {
        if (IsAPPROVE)
            return 1;
        else
            return 2;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    PublishCell *cell2;
    switch (indexPath.section) {
        case 0:
            cell1 = [tablemenu dequeueReusableCellWithIdentifier:@"cell1"];
            
            
            return cell1;
        case 1:
            cell2 = [tablemenu dequeueReusableCellWithIdentifier:@"cell2"];
            if (indexPath.row==0)
            {
                cell2.cellimg.image=[UIImage imageNamed:@"sendmubiao"];
                cell2.celltitle.text=@"发送目标";
                cell2.cellcontent.text=selectdepartmentlist;
            }else if (indexPath.row==1)
            {
                cell2.cellimg.image=[UIImage imageNamed:@"shenpiren"];
                cell2.celltitle.text=@"审批领导";
                cell2.cellcontent.text=approveruser;
            }
            
            return cell2;
    }
    
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectListViewController *selectvc;
    if (indexPath.section ==1)
    {
        switch (indexPath.row) {
            case 0:
                selectvc = (SelectListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"selectList"];
                selectvc.titleCommon=@"选择发送目标";
                selectvc.listtype = DEPARTMENT;
                selectvc.delegateVC=self;
                [self presentViewController:selectvc animated:YES completion:nil];
                
                break;
            case 1:
                selectvc = (SelectListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"selectList"];
                selectvc.titleCommon=@"选择审批人";
                selectvc.listtype =APPOVER ;
                selectvc.delegateVC=self;
                [self presentViewController:selectvc animated:YES completion:nil];
                
                break;
                
        }
    }
}
-(void)closeinput
{
    [edittitle resignFirstResponder];
    [content resignFirstResponder];
}

//发送
-(void)Clicksend
{
    if ([edittitle.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入调度标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([content.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入调度内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (!selectdepartmentidlist)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择发送目标" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![[UserInfo getInstance].auth containsObject:@"DISPATCH_APPROVE"])
    {
        if (!approveruserid)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择审批人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    recordfileid = [cell1 getRecordFileName];
    if (recordfileid)
    {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"是否包含录音信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
             [self submitFile];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else
    {
        [self submitFile];
    }
    
    
}


-(void)submitFile
{
    __block BOOL Isfinish =NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    
    hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    [hub show:YES];

    if (recordfileid)
    {
        //文件上传
        dispatch_group_async(group,globalQ, ^{
            HttpServer *http = [[HttpServer alloc] init:UploadUrl];
            
            NSString * urlStr=[[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",recordfileid]];
            NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:urlStr]];
            
            ReturnData *rd =  [http uploadfile:filedata mediaid:recordfileid mediatype:@"02" filetype:@".aac"];
            if (rd && rd.returnCode==0)
                Isfinish=YES;
            else
                Isfinish=NO;

        });
    }

    
    if ([mediaids count] >0)
    {
        for (NSString *imgid in mediaids) {
            //文件上传
            dispatch_group_async(group,globalQ, ^{
                HttpServer *http = [[HttpServer alloc] init:UploadUrl];
                NSString * urlStr=[[FileCommon getCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imgid]];
                NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:urlStr]];
                
                ReturnData *rd =  [http uploadfile:filedata mediaid:imgid mediatype:@"02" filetype:@".jpg"];
                if (rd && rd.returnCode==0)
                    Isfinish=YES;
                else
                    Isfinish=NO;
            });
        }
    }
    dispatch_group_notify(group, globalQ, ^{
       
        if (recordfileid && [mediaids count] >0 && !Isfinish)
        {
            //失败
            dispatch_async(mainQ, ^{
                [hub hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败，请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return ;
                
            });
            return ;
        }
        
        
        HttpServer *http = [[HttpServer alloc] init:saveDispatchMsg];
   
            
       ReturnData *sendResult =  [http publishJDInfo:edittitle.text content:content.text recordfile:(!recordfileid)?@"":recordfileid pics:([mediaids count]>0)?[mediaids componentsJoinedByString:@","]:@"" group_ids:selectdepartmentidlist approve_account_id:approveruserid];
        
        dispatch_async(mainQ, ^{
            [hub hide:YES];
            
            if (!sendResult){
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败，请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            return ;
            }
            else
            {
                
                NSLog(@"发布成功");
            
            
            }
            
        });

        
        // 发布调度
    });

  
}


-(void)submitInfo
{
    
    
    
}




-(void)SelectedSendInfo:(NSString *)itemid name:(NSString *)name
{
    selectdepartmentlist = name;
    selectdepartmentidlist = itemid;
    [tablemenu reloadData];
}

-(void)SelectedAPPOVERInfo:(NSString *)itemid name:(NSString *)name
{
    approveruser=name;
    approveruserid=itemid;
    [tablemenu reloadData];
}
-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
