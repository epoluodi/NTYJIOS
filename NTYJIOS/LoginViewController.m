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

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginview;
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
    [btnlogin  setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnlogin  setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [btnlogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btnlogin];
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
}
@end
