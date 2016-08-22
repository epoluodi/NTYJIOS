//
//  LoginViewController.m
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import "LoginViewController.h"
#import <Common/PublicCommon.h>
#import "Common.h"
#import "HttpServer.h"
#import "MBProgressHUD.h"
#import "DBmanger.h"

@interface LoginViewController ()
{
    MBProgressHUD *hub;
}


@end

@implementation LoginViewController
@synthesize loginview;


-(void)awakeFromNib
{
    _IsAutoLogin=YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    loginview.backgroundColor=[UIColor clearColor];
    btnlogin.backgroundColor = [UIColor clearColor];
    IsShow = NO;
    loginview.layer.borderColor=[[[UIColor blackColor] colorWithAlphaComponent:0.15] CGColor];
    loginview.layer.borderWidth=1;
    loginview.layer.cornerRadius=6;
    loginview.layer.masksToBounds=YES;
   
        // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!IsShow){
        [self InitLoginView];
        IsShow=YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitLoginView
{
    UIImageView *imgview1 = [[UIImageView alloc] init];
    imgview1.image= [UIImage imageNamed:@"user_icon"];
    imgview1.frame= CGRectMake(0, 0, 30, 30);
    UIImageView *imgview2 = [[UIImageView alloc] init];
    imgview2.image= [UIImage imageNamed:@"pwd_icon"];
    imgview2.frame= CGRectMake(0, 0, 30, 30);
    loginview.userInteractionEnabled=YES;
    useredit = [[UITextField alloc] init];
    useredit.placeholder=@"用户";
    useredit.clearButtonMode = UITextFieldViewModeWhileEditing;
    useredit.frame = CGRectMake(20, 10, loginview.frame.size.width-40, 40);
    useredit.autocorrectionType = UITextAutocorrectionTypeNo;
    [useredit setLeftView:imgview1];
    useredit.leftViewMode = UITextFieldViewModeAlways;
    useredit.keyboardType = UIKeyboardTypeDefault;
    useredit.returnKeyType=UIReturnKeyDone;
    useredit.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    [loginview addSubview:useredit];
    
    pwdedit = [[UITextField alloc] init];
    pwdedit.placeholder=@"密码";
    pwdedit.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdedit.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    pwdedit.keyboardType = UIKeyboardTypeNumberPad;
    pwdedit.returnKeyType=UIReturnKeyDone;
    pwdedit.autocorrectionType = UITextAutocorrectionTypeNo;
    pwdedit.secureTextEntry = YES; //密码
    pwdedit.frame = CGRectMake(20, 70, loginview.frame.size.width-40, 40);
    [pwdedit setLeftView:imgview2];
    pwdedit.leftViewMode = UITextFieldViewModeAlways;
    [loginview addSubview:pwdedit];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame=CGRectMake(0, 0, loginview.frame.size.width, loginview.frame.size.height);
    [shapeLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 15, loginview.frame.size.height/2 );
    CGPathAddLineToPoint(path, NULL, loginview.frame.size.width -15,loginview.frame.size.height/2 );
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [loginview.layer addSublayer:shapeLayer];
    
    //登录按钮
    btnlogin = [[UIButton alloc] init];
    btnlogin.frame=CGRectMake(loginview.frame.origin.x, loginview.frame.origin.y +
                              loginview.frame.size.height + 60, loginview.frame.size.width, 40);
    UIImage *image1 = [PublicCommon createImageWithColor:APPCOLOR Rect:CGRectMake(0, 0, 100, 100)];
    UIImage *image2 = [PublicCommon createImageWithColor:APPCOLORDOWN Rect:CGRectMake(0, 0, 100, 100)];
    btnlogin.layer.cornerRadius=6;
    btnlogin.layer.masksToBounds=YES;
    [btnlogin addTarget:self action:@selector(ClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btnlogin  setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnlogin  setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [btnlogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btnlogin];
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    useredit.text=[userinfo objectForKey:@"username"];
    pwdedit.text=[userinfo objectForKey:@"userpwd"];
 
    if (![[UserInfo getInstance].sysUserName isEqualToString:@""] && ![[UserInfo getInstance].userPwd isEqualToString:@""]
        )
    {
        if (_IsAutoLogin)
            [self ClickLogin:nil];
    }

    
}

-(void)closeinput
{
    [useredit resignFirstResponder];
    [pwdedit resignFirstResponder];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)ClickLogin:(id)sender {
    
    if ([useredit.text isEqualToString:@""] ||
        [pwdedit.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    [self closeinput];
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    hub=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    [hub show:YES];

    
    dispatch_async(globalQ, ^{
        HttpServer *http = [[HttpServer alloc] init:LoginUrl];
        NSDictionary * r =  [http Login:useredit.text userpwd:pwdedit.text];
        NSLog(@"%@",r);
        if (!r)
        {
            [self Loginresult:NO msg:@"登录失败,请重新尝试登录"];
            return;
        }
        NSNumber *ret =  [r objectForKey:@"status"];
        
        if (ret.intValue != 0)
        {
            [self Loginresult:NO msg:@"登录失败,请重新尝试登录"];
            return;
        }
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setObject:useredit.text forKey:@"username"];
        [userinfo setObject:pwdedit.text forKey:@"userpwd"];
        NSDictionary *data = [r objectForKey:@"data"];
        NSDictionary*mqtt = [data objectForKey:@"MQTT"];
        [ServerInfo getInstance].MQTTADDRESS = [mqtt objectForKey:@"mqttaddress"];
        [ServerInfo getInstance].MQTTPORT =(INT_PORT)((NSString*) [mqtt objectForKey:@"mqttport"]).intValue;
        [ServerInfo getInstance].username =[mqtt objectForKey:@"username"];
        [ServerInfo getInstance].password =[mqtt objectForKey:@"password"];
        
        [UserInfo getInstance].Token = [data objectForKey:@"token"];
        NSDictionary *user = [data objectForKey:@"user"];
        NSLog(@"user %@",user);
        [UserInfo getInstance].userName =[user objectForKey:@"userName"];
        [UserInfo getInstance].sysUserName =[user objectForKey:@"sysUserName"];
        [UserInfo getInstance].userId =[user objectForKey:@"accountId"];
        [UserInfo getInstance].picture =[user objectForKey:@"picture"];
        [UserInfo getInstance].sex =[user objectForKey:@"sex"];
        [UserInfo getInstance].tel =[user objectForKey:@"tel"];
        [UserInfo getInstance].positionId =[user objectForKey:@"positionId"];
        [UserInfo getInstance].positionName =[user objectForKey:@"positionName"];
        [UserInfo getInstance].auth =[user objectForKey:@"auths"];
        [UserInfo getInstance].nickimg=[UIImage imageNamed:@"default_avatar"];
    
        http =[[HttpServer alloc] init:queryGroups];
        BOOL result = [http getdepartmentinfo];
        if (!result)
        {
            [self Loginresult:NO msg:@"获得部门信息失败"];
            return;
        }
        http =[[HttpServer alloc] init:queryUsers];
        result = [http getdepartmentUserinfo];
        if (!result)
        {
            [self Loginresult:NO msg:@"获得部门成员信息失败"];
            return;
        }
        result = [http getGroupsList];
        if (!result)
        {
            [self Loginresult:NO msg:@"获得调度信息失败"];
            return;
        }
        [self Loginresult:YES msg:nil];
        
    });
    
    
    
}


-(void)Loginresult:(BOOL)result msg:(NSString *)msg
{
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_async(mainQ, ^{
        [hub hide:YES];
        if (!result)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        else{
        
            [_mainview ConnectMqtt];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    });
}

@end
