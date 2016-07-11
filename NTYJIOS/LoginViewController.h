//
//  LoginViewController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/11.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    UITextField *useredit;
    UITextField *pwdedit;
    UIButton *btnlogin;
    BOOL IsShow;
}

@property (weak, nonatomic) IBOutlet UIView *loginview;





@end
