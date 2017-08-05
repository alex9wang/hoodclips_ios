//
//  LoginViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    BOOL chk_rem;
    BOOL chk_auto;
}
@property (strong,nonatomic)IBOutlet UIButton    *btn_rem;
@property (strong,nonatomic)IBOutlet UIButton    *btn_auto;
@property (strong,nonatomic)IBOutlet UIButton    *btn_login;

-(IBAction)clickRemeber:(id)sender;
-(IBAction)clickAuto:(id)sender;
-(IBAction)clickLogin:(id)sender;
@end
