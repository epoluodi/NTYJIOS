//
//  ModiPwdController.h
//  NTYJIOS
//
//  Created by Stereo on 16/7/8.
//  Copyright © 2016年 Suypower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModiPwdController : UIViewController
{
    UIBarButtonItem *btnreturn;
    UIBarButtonItem *btnconfim;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;

@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd2;

@end
