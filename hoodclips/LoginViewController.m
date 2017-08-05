//
//  LoginViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize btn_auto,btn_rem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        chk_auto = FALSE;
        chk_rem = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)clickRemeber:(id)sender
{
    if(chk_rem)
    {
        [btn_rem setImage:[UIImage imageNamed:@"btn_check_off"] forState: UIControlStateNormal];
        chk_rem = FALSE;
    }
    else
    {
        [btn_rem setImage:[UIImage imageNamed:@"btn_check_on"] forState: UIControlStateNormal];
        chk_rem = TRUE;
    }
}
-(IBAction)clickAuto:(id)sender
{
    if(chk_auto)
    {
        [btn_auto setImage:[UIImage imageNamed:@"btn_check_off"] forState: UIControlStateNormal];
        chk_auto = FALSE;
    }
    else
    {
        [btn_auto setImage:[UIImage imageNamed:@"btn_check_on"] forState: UIControlStateNormal];
        chk_auto = TRUE;
    }
}
-(IBAction)clickLogin:(id)sender
{
    [[AppDelegate shardAppDeleget]showAllVideos];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
