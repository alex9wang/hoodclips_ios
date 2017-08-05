//
//  ConnectionErrorViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "ConnectionErrorViewController.h"
#import "AppDelegate.h"

@interface ConnectionErrorViewController() {
}

@end

@implementation ConnectionErrorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
