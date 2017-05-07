//
//  JDDeltalViewController.m
//  NTYJIOS
//
//  Created by 程嘉雯 on 16/9/10.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "JDDeltalViewController.h"
#import <Common/PublicCommon.h>
#import <Common/FileCommon.h>
#import "HttpServer.h"
#import "FTPopOverMenu.h"
#import "MBProgressHUD.h"

@interface JDDeltalViewController ()
{
    MediaRecord *mediacontroll;
    __block UITextField * _textfield;
    MBProgressHUD *hud;
    
}
@end

@implementation JDDeltalViewController
@synthesize IsAppoverMode;
@synthesize navbar;
@synthesize btnaudio;
@synthesize infoview,info_title,infoscroll;
@synthesize sender,sendtime;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnaudio.hidden=YES;
    if (IsAppoverMode){
        navbar.items[0].title=@"信息审批";
        btnright = [[UIBarButtonItem alloc] initWithTitle:@"审批" style:UIBarButtonItemStylePlain target:self action:@selector(ClickRight)];
        [btnright setTintColor :[UIColor whiteColor] ];
        [navbar.items[0] setRightBarButtonItem:btnright];
    }
    else
        navbar.items[0].title=@"信息";
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(ClickReturn)];
    [btnreturn setTintColor :[UIColor whiteColor] ];
    [navbar.items[0] setLeftBarButtonItem:btnreturn];
    infoview.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1]CGColor];
    infoview.layer.borderWidth=1;

    
    
    info_title.text = [_info objectForKey:@"dispatch_title"];
    sender.text =[NSString stringWithFormat:@"发送人:%@",[_info objectForKey:@"send_user_name"]] ;
    sendtime.text =[NSString stringWithFormat:@"发布时间:%@",[_info objectForKey:@"create_time"]];
    
    audioid = [_info objectForKey:@"audio_id"];
    
    
    if (![audioid isEqualToString:@""])
        [self DownloadAudio:audioid];
    
    if (![[_info objectForKey:@"pic_ids"] isEqualToString:@""])
    {
        pics =[[_info objectForKey:@"pic_ids"] componentsSeparatedByString:@","];
    }
    
    infoscroll.pagingEnabled=NO;
    infoscroll.bounces=YES;
    infoscroll.scrollEnabled=YES;
    infoscroll.showsVerticalScrollIndicator=YES;
    infoscroll.alwaysBounceHorizontal=NO;
    infoscroll.showsHorizontalScrollIndicator=NO;
    infoscroll.alwaysBounceVertical=YES;
    infoscroll.contentSize = CGSizeMake(0,infoscroll.frame.size.height);
    infoscroll.userInteractionEnabled=YES;
    [self initContentView];
    
    // Do any additional setup after loading the view.
}


-(void)initContentView
{
    UILabel*   content = [[UILabel alloc] init];
    NSString *_content = [_info objectForKey:@"dispatch_content"];
    CGRect tmpRect = [_content boundingRectWithSize:CGSizeMake([PublicCommon GetALLScreen].size.width-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
  
    content.text = _content;
    content.font = [UIFont systemFontOfSize:18];
    content.numberOfLines=0;
    
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.frame = CGRectMake(10, 10, [PublicCommon GetALLScreen].size.width-20, tmpRect.size.height+10);
    [infoscroll addSubview:content];
    int i=0;
    if (pics)
    {
        for (NSString *_picid in pics) {
            UIImageView *imgview = [[UIImageView alloc] init];
            imgview.contentMode = UIViewContentModeScaleAspectFit;
            imgview.frame = CGRectMake(10, (content.frame.origin.y + content.frame.size.height +15) + (i *220 )+(i*15), [PublicCommon GetALLScreen].size.width-20, 220);
            imgview.layer.shadowOffset = CGSizeMake(8, 6);
            imgview.layer.shadowColor =[[UIColor grayColor]CGColor];
            imgview.layer.shadowRadius =5;
            imgview.layer.shadowOpacity =0.8f;
            imgview.image = [UIImage imageNamed:@"logo"];
            [infoscroll addSubview:imgview];
            [self DownloadImg:_picid imgview:imgview];
            i++;
            
        }
        
    }
    
    infoscroll.contentSize =CGSizeMake( 0,content.frame.size.height + (i+1)*220 + 30);
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
-(void)DownloadAudio:(NSString *)mediaid
{
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(globalQ, ^{
        
        
        NSFileManager *filemanger = [NSFileManager defaultManager];
        NSString *path = [FileCommon getCacheDirectory];
        NSString* _filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",mediaid]];
        
        
        __block NSData *aacdata;
        if (![filemanger fileExistsAtPath:_filename])
        {
            HttpServer *http = [[HttpServer alloc] init:DownloadUrl];
            aacdata = [http FileDownload:mediaid suffix:@"" mediatype:@".aac"];
            mediacontroll = [[MediaRecord alloc] initAudio:aacdata];
            mediacontroll.delegate=self;
            dispatch_async(mainQ, ^{
                
                if (aacdata){
                    btnaudio.hidden=NO;
                }
            });
        }
        else
        {
            aacdata = [NSData dataWithContentsOfFile:_filename];
            mediacontroll = [[MediaRecord alloc] initAudio:aacdata];
            mediacontroll.delegate=self;
            dispatch_async(mainQ, ^{
                btnaudio.hidden=NO;
            });
            
        }
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)ClickReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//审批
-(void)ClickRight
{
    
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-30,0, 0, 64)
                              withMenu:@[@"审批",@"拒绝",]
                        imageNameArray:@[@"sp_ok",@"sp_no"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 UIAlertController *alert;
                                 switch (selectedIndex) {
                                     case 0://审批
                                         [self AppoverInfoSubmit:YES];
                                         break;
                                     case 1:
                                        alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"拒绝说明(可以为空)" preferredStyle:UIAlertControllerStyleAlert];
                                         [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                             _textfield = textField;
                                         }];
                                        
                                         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             [_textfield resignFirstResponder];
                                              [self AppoverInfoSubmit:NO];
                                         }];
                                         [alert addAction:action1];
                                
                                         
                                         [self presentViewController:alert animated:YES completion:nil];
                                         
                                         break;
                                 }
                                 
                             } dismissBlock:^{
                                 
                                 NSLog(@"user canceled. do nothing.");
                                 
                             }];
}



//审核
-(void)AppoverInfoSubmit:(BOOL)result
{
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_async(globalQ, ^{
        HttpServer *http = [[HttpServer alloc] init:approveDispatchMsg];
        BOOL r =  [http ApproveDispatchMsg:[_info objectForKey:@"dispatch_id"] approve_result:result?@"01":@"02" approve_desc:_textfield.text send_account_id:[_info objectForKey:@"send_account_id"] send_user_name:[_info objectForKey:@"send_user_name"]];
        dispatch_async(mainQ, ^{
            [hud hide:YES];
            if (r)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"审批完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
                [_previousVC dismissViewControllerAnimated:NO completion:nil];
                return ;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"审核失败，请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        });
        
    });
    
    
    
    
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

- (IBAction)ClickAudio:(id)sender {
    if ([mediacontroll getPlayState]){
        [mediacontroll audioStop];
        [ btnaudio setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else{
        [mediacontroll audioPlayer];
        [ btnaudio setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    
}


-(void)OnPlayEnd
{
    [ btnaudio setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}



@end
