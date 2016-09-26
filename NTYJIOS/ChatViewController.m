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
- (void)viewDidLoad {
    [super viewDidLoad];
    navtitle.title = @"调度讨论";
    [self.navigationController.navigationItem.leftBarButtonItems[0] setTintColor:[UIColor  whiteColor]];
    app = [[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:UIColorFromRGB(0xEAEAEA)];
    
    
    
    
    infoimg.contentMode = UIViewContentModeScaleAspectFill;
    infoimg.layer.masksToBounds=YES;
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickddinfo)];
    
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    
    [_contentview addGestureRecognizer:tap];
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(globalQ, ^{
        HttpServer *http = [[HttpServer alloc] init:readDispatchMsg];
        
      
        BOOL r =    [http readDispatchStateSendServer:_ddinfo.ddid  lng:  [NSString stringWithFormat:@"%f",app.loc.location.coordinate.longitude] lat:  [NSString stringWithFormat:@"%f",app.loc.location.coordinate.latitude]];
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
        
        dispatch_async(globalQ, ^{
            
            HttpServer *http = [[HttpServer alloc] init:queryDispatchMsg];
            ReturnData *ret =[http queryDDInfo:_ddinfo.ddid];
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
        groupinfovc.ddid = _ddinfo.ddid;
        
        groupinfovc.senddt =[_ddinfo.sendtime timeIntervalSince1970];
        return;
    }
}









@end
