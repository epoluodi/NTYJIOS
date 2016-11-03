//
//  ChatViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/16.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "ChatViewController.h"
#import "MBProgressHUD.h"
#import "HttpServer.h"
#import <Common/PublicCommon.h>
#import <Common/FileCommon.h>
#import "JDDeltalViewController.h"
#import "GroupInfoViewController.h"
#import "AppDelegate.h"
#import "ChatTextLeftCell.h"
#import "ChatTextRightCell.h"
#import "MainTabBarController.h"
#import "UserInfo.h"


@interface ChatViewController ()
{
    MBProgressHUD *hud;
    AppDelegate *app;
}

@end

@implementation ChatViewController
@synthesize navtitle;
@synthesize infodt,infoimg,infotitle,infocontent;
@synthesize cotentH,imgH;
@synthesize chatcontent;
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    navtitle.title = @"调度讨论";
    [self.navigationController.navigationItem.leftBarButtonItems[0] setTintColor:[UIColor  whiteColor]];
    app = [[UIApplication sharedApplication] delegate];

    [table setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapchat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeinput)];
    [table addGestureRecognizer:tapchat];
    
    ((MainTabBarController *)self.tabBarController).nowVC=self;
    
    chatlists = [[NSMutableArray alloc] init];
    cellHlist = [[NSMutableDictionary alloc] init];
    [chatlists addObjectsFromArray:  [[DBmanger getIntance] getChatLog:_ddinfo]];
    UINib *nib = [UINib nibWithNibName:@"chatleft_text_cell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"textleftcell"];
    nib = [UINib nibWithNibName:@"chat_right_text_cell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"textrightcell"];
    
    table.delegate=self;
    table.dataSource=self;
    

    
    chatcontent.delegate=self;
    
    
    infoimg.contentMode = UIViewContentModeScaleAspectFill;
    infoimg.layer.masksToBounds=YES;
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickddinfo)];
    
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    
    [_contentview addGestureRecognizer:tap];
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), globalQ, ^{
        HttpServer *http = [[HttpServer alloc] init:readDispatchMsg];
        
        
        BOOL r =    [http readDispatchStateSendServer:_ddinfo  lng:  [NSString stringWithFormat:@"%f",app.loc.location.coordinate.longitude] lat:  [NSString stringWithFormat:@"%f",app.loc.location.coordinate.latitude]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!r)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器，信息无法反馈，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            return ;
        });
    });
   
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
        ((MainTabBarController *)self.tabBarController).nowVC=nil;
}
//关闭键盘
-(void)closeinput
{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.4f];
    
    _inputautoH.constant=0;
    [UIView commitAnimations];
    
    [chatcontent resignFirstResponder];
}
//点击调度信息
-(void)clickddinfo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JDDeltalViewController *jddetailview= [storyboard instantiateViewControllerWithIdentifier:@"jddetail"];
    jddetailview.IsAppoverMode=NO;
    jddetailview.previousVC=self;
    jddetailview.info = ddinfodict;
    [self presentViewController:jddetailview animated:YES completion:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    if (!ddinfodict){
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        [hud show:YES];
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), globalQ, ^{
            
            HttpServer *http = [[HttpServer alloc] init:queryDispatchMsg];
            ReturnData *ret =[http queryDDInfo:_ddinfo];
            dispatch_async(mainQ, ^{
                [hud hide:YES];
                if (!ret)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取调度信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                else{
                    btnright = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"groups_white"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickGroup)];
                    [btnright setTintColor :[UIColor whiteColor] ];
                    
                    [navtitle setRightBarButtonItem:btnright];
                    
                    
                    
                    NSString *picid1;
                    ddinfodict = [ret returnData];
                    NSLog(@"%@",ddinfodict);
                    infotitle.text = [ddinfodict objectForKey:@"dispatch_title"];
                    
                    infodt.text =    [PublicCommon getDateStringWithDT:[ddinfodict objectForKey:@"create_time"]];
                    if (![[ddinfodict objectForKey:@"pic_ids"] isEqualToString:@""])
                    {
                        NSArray *picaary =[[ddinfodict objectForKey:@"pic_ids"] componentsSeparatedByString:@","];
                        picid1 = picaary[0];
                        
                        [self DownloadImg:picid1 imgview:infoimg];
                    }
                    else
                    {
                        imgH.constant=0;
                    }
                    NSString *content = [ddinfodict objectForKey:@"dispatch_content"];
                    
                    CGRect tmpRect = [content boundingRectWithSize:CGSizeMake(infocontent.frame.size.width, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
                    cotentH.constant = tmpRect.size.height;
                    infocontent.text = content;
                }
            });
        });
       
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (chatlists.count > 0)
        {
            [self tableView:table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0]];
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count] -1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
  
}


//点击讨论组
-(void)ClickGroup
{
    [self performSegueWithIdentifier:@"showgroupinfo" sender:self];
}
-(void)DownloadImg:(NSString *)mediaid imgview:(UIImageView *)imgview
{
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(globalQ, ^{
        
        
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",mediaid]];
        
        
        __block NSData *jpgdata;
        if (![filemanger fileExistsAtPath:_filename])
        {
            HttpServer *http = [[HttpServer alloc] init:DownloadUrl];
            jpgdata = [http FileDownload:mediaid suffix:@"aumb" mediatype:@".jpg"];
            dispatch_async(mainQ, ^{
                
                if (jpgdata){
                    imgview.image = [UIImage imageWithData:jpgdata];
                }
            });
        }
        else
        {
            dispatch_async(mainQ, ^{
                jpgdata = [NSData dataWithContentsOfFile:_filename];
                imgview.image = [UIImage imageWithData:jpgdata];
            });
            
        }
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

\
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showgroupinfo"])
    {
        GroupInfoViewController *groupinfovc = [segue destinationViewController];
        groupinfovc.ddid = _ddinfo;
        
        groupinfovc.senddt =[_ddinfocreatedt timeIntervalSince1970];
        return;
    }
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
 
  
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.4f];
    
    _inputautoH.constant=216;
    [UIView commitAnimations];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeinput];
    return YES;
}



#pragma mark 聊天

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatlists count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *h =[cellHlist objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
 
    return [h intValue]+3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    ChatTextLeftCell *cell = [table dequeueReusableCellWithIdentifier:@"textleftcell"];
// 
//    [cell setInfo:[NSString stringWithFormat:@"%d",indexPath.row] dt:@""];
//    [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)cell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//       tablescrollcontentHeight += cell.CellHight;
    
    ChatTextRightCell *cell = [table dequeueReusableCellWithIdentifier:@"textrightcell"];
    
    
    ChatLog *chatmsg = chatlists[indexPath.row];
    NSString *olddt;
    if (indexPath.row-1 >=0)
    {
        ChatLog *oldchatlog =chatlists[indexPath.row-1];
        olddt =oldchatlog.msgdate;
    }
    else
        olddt=nil;
    
    
    Contacts * contacts = [[DBmanger getIntance] getContactswithuserId:chatmsg.senderid];
    if ([chatmsg.isself isEqual:@1])
    {
        ChatTextLeftCell *leftcell =[table dequeueReusableCellWithIdentifier:@"textleftcell"];
        
        if ([chatmsg.msgType isEqual:@1])
        {
            [leftcell setInfo:chatmsg.content  dt:chatmsg.msgdate olddt:olddt];
            leftcell.sendname.text=contacts.name;
            [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)leftcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }else if ([chatmsg.msgType isEqual:@2])
        {
            
            [leftcell setInfodt:chatmsg.msgdate olddt:olddt];
            [leftcell setImgMsg:chatmsg.content];
            leftcell.sendname.text=contacts.name;
            [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)leftcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }else if ([chatmsg.msgType isEqual:@3])
        {
            
            [leftcell setInfodt:chatmsg.msgdate olddt:olddt];
            [leftcell setAduioInfo:chatmsg.content];
            leftcell.sendname.text=contacts.name;
            [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)leftcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
//        leftcell.sendname.text=chatmsg.sender;
//        [leftcell setInfo:chatmsg.content  dt:chatmsg.msgdate olddt:olddt];
//        [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)leftcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
         //头像
        if (contacts){
            leftcell.nickimg.contentMode=UIViewContentModeScaleAspectFit;
            NSFileManager *filemanger = [NSFileManager defaultManager];
            NSString *path = [FileCommon getCacheDirectory];
            NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",contacts.img]];
            
            
            NSData *jpgdata;
            if ([filemanger fileExistsAtPath:_filename])
            {
                jpgdata = [NSData dataWithContentsOfFile:_filename];
                leftcell.nickimg.image = [UIImage imageWithData:jpgdata];
            }
            else
                leftcell.nickimg.image = [UIImage imageNamed:@"default_user"];
        }
        
        return leftcell;
    }
    if ([chatmsg.isself isEqual:@2])
    {
        ChatTextRightCell *rightcell =[table dequeueReusableCellWithIdentifier:@"textrightcell"];
        
        
       if ([chatmsg.msgType isEqual:@1])
       {
           [rightcell setInfo:chatmsg.content  dt:chatmsg.msgdate olddt:olddt];
           [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)rightcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
       }else if ([chatmsg.msgType isEqual:@2])
       {
           
           [rightcell setInfodt:chatmsg.msgdate olddt:olddt];
           [rightcell setImgMsg:chatmsg.content];
            [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)rightcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
       }else if ([chatmsg.msgType isEqual:@3])
       {
           
           [rightcell setInfodt:chatmsg.msgdate olddt:olddt];
           [rightcell setAduioInfo:chatmsg.content];
           [cellHlist setObject:[NSString stringWithFormat:@"%lu",(unsigned long)rightcell.CellHight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
       }
       
        
        //头像
        if (contacts){
            rightcell.nickimg.contentMode=UIViewContentModeScaleAspectFit;
            NSFileManager *filemanger = [NSFileManager defaultManager];
            NSString *path = [FileCommon getCacheDirectory];
            NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",contacts.img]];
            
            
            NSData *jpgdata;
            if ([filemanger fileExistsAtPath:_filename])
            {
                jpgdata = [NSData dataWithContentsOfFile:_filename];
                rightcell.nickimg.image = [UIImage imageWithData:jpgdata];
            }
            else
                rightcell.nickimg.image = [UIImage imageNamed:@"default_user"];

        }
        
        return rightcell;
    }


   

    
    return cell;
}

-(void)OnMessage:(id)msg
{
    ChatLog *chatmsg = (ChatLog *)msg;
    
    
    
    [chatlists addObject:chatmsg];
    if (![chatmsg.groupid isEqualToString:_ddinfo])
        return;
  
    dispatch_async(dispatch_get_main_queue(), ^{
        [self tableView:table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0]];
        //    [table beginUpdates];
        //    [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0] ] withRowAnimation:UITableViewRowAnimationLeft];
        //
        //    [table endUpdates];
        
        [table reloadData];
        //
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    });
    
    
    
    
    NSLog(@"chatmsg %@",chatmsg);
}



-(void)FinishRecord:(NSString *)filename duration:(int)duration
{
    NSLog(@"文件 %@",filename);
      NSLog(@"文件时长 %d",duration);
    
    NSString *filePath = [FileCommon getCacheDirectory];
   
    
    //    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //
    NSString *path =[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",filename]];

    
    
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
        
        HttpServer *http = [[HttpServer alloc] init:UploadUrl];
        
        
        NSData *recorddata= [NSData dataWithContentsOfFile:path];
        
        ReturnData *rd =  [http uploadfile:recorddata mediaid:filename mediatype:@"02" filetype:@".aac"];
        if (rd && rd.returnCode==0)
        {
            NSMutableDictionary *mDict=[[NSMutableDictionary alloc] init];
            [mDict setObject:@"03" forKey:@"msg_type"];
            [mDict setObject:filename forKey:@"msg_content"];
            [mDict setObject:_ddinfo forKey:@"dispatch_id"];
            
            HttpServer* http2  = [[HttpServer alloc] init:saveSessionMsg];
            BOOL r =  [http2 sendMsg:mDict];
            
            dispatch_async(mainQ, ^{
                if (!r)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败，可能网络问题请重新尝试!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    return ;
                }
                
                chatcontent.text=@"";
            });
            
            
        }
        else
        {
            dispatch_async(mainQ, ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败，可能网络问题请重新尝试!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return ;
                
                
                chatcontent.text=@"";
            });
        }
        
    });
    

    
    
    
    
}
//录音
- (IBAction)clickaudio:(id)sender {
    
    
  
    
    
    RecordView *recordview = [[RecordView alloc] init:self.tabBarController.view.frame];
    recordview.delegate=self;
    [self.tabBarController.view addSubview:recordview];
    
    
    
}

- (IBAction)clickpicture:(id)sender {
    [self closeinput];
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
    
//    image = [PublicCommon scaleToSize:image size:CGSizeMake(512, 512)];
    
    
    __block NSData *jpgdata = UIImageJPEGRepresentation(image, 0.5);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [FileCommon getCacheDirectory];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    //    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    //
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",uuid];
    [fileManager createFileAtPath:[filePath stringByAppendingPathComponent:filename] contents:jpgdata attributes:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
       
        HttpServer *http = [[HttpServer alloc] init:UploadUrl];
     
        
        ReturnData *rd =  [http uploadfile:jpgdata mediaid:uuid mediatype:@"02" filetype:@".jpg"];
        if (rd && rd.returnCode==0)
        {
            NSMutableDictionary *mDict=[[NSMutableDictionary alloc] init];
            [mDict setObject:@"02" forKey:@"msg_type"];
            [mDict setObject:uuid forKey:@"msg_content"];
            [mDict setObject:_ddinfo forKey:@"dispatch_id"];
            
           HttpServer* http2  = [[HttpServer alloc] init:saveSessionMsg];
            BOOL r =  [http2 sendMsg:mDict];
            
            dispatch_async(mainQ, ^{
                if (!r)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败，可能网络问题请重新尝试!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    return ;
                }
                
                chatcontent.text=@"";
            });
            
            
        }
        else
        {
            dispatch_async(mainQ, ^{
               
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败，可能网络问题请重新尝试!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    return ;
                
                
                chatcontent.text=@"";
            });
        }
        
    });
   

    
}




- (IBAction)clicksend:(id)sender {
    

    if ([chatcontent.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送空内容!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    
    NSMutableDictionary *mDict=[[NSMutableDictionary alloc] init];
    [mDict setObject:@"01" forKey:@"msg_type"];
    [mDict setObject:chatcontent.text forKey:@"msg_content"];
    [mDict setObject:_ddinfo forKey:@"dispatch_id"];

    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    
    
    dispatch_async(globalQ, ^{
       
        HttpServer *http  = [[HttpServer alloc] init:saveSessionMsg];
        BOOL r =  [http sendMsg:mDict];
        
        dispatch_async(mainQ, ^{
           if (!r)
           {
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败，可能网络问题请重新尝试!!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
               [alert show];
               return ;
           }
            
            chatcontent.text=@"";
            
            
            
        });
    });
    

//    [self tableView:table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0]];
//    [table beginUpdates];
//    [table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0] ] withRowAnimation:UITableViewRowAnimationLeft];
//    
//    [table endUpdates];
//
////
//    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatlists count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    


}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
