//
//  HomeViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "HomeViewController.h"
#import "SlideMenuController.h"
#import "MenuViewController.h"
#import "UIUtils.h"

@interface HomeViewController () {
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self gotoTredingVideoPage];
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoTredingVideoPage {
    UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    MenuViewController* leftController = (MenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    [self.navigationController setViewControllers:@[menuController]];
}


@end
