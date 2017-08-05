//
//  LeftViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+SlideMenu.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import "PurchaseViewController.h"
#import "Analytics.h"
#import "Env.h"
#import "AppDelegate.h"
#import "AllVideoViewController.h"

@import GoogleMobileAds;

@import MessageUI;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate,  MFMailComposeViewControllerDelegate> {
    
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect frame = tableView.frame;
    return frame.size.width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController* navController = (UINavigationController*)[self slideMenuController].mainViewController;
    UIStoryboard *mainStoryboard = self.storyboard;// [UIStoryboard storyboardWithName:@"hoodclips" bundle: nil];
    
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
        {
            AllVideoViewController *allVideoVC = (AllVideoViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AllVideoViewController"];
            [allVideoVC setViewType:0];
            vc = allVideoVC;
        }
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TrendingViewController"];
            break;
            
        case 1:
        {
            AllVideoViewController *allVideoVC = (AllVideoViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AllVideoViewController"];
            [allVideoVC setViewType:2];
            vc = allVideoVC;
        }
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllVideoViewController"];
            break;
            
        case 2:
        {
            AllVideoViewController *allVideoVC = (AllVideoViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AllVideoViewController"];
            [allVideoVC setViewType:1];
            vc = allVideoVC;
        }
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FavoriteViewController"];
            break;
            
//        case 3:
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PurchaseViewController"];
//            break;
            
        case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AboutViewController"];
            break;
            
        case 4:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SearchViewController"];
            break;
    }
    
    [navController popToRootViewControllerAnimated:NO];
    [navController pushViewController:vc animated:NO];
    
    [[self slideMenuController] closeLeft];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    UIImageView*    imgMark = [cell viewWithTag:1000];
    
    switch (indexPath.row)
    {
        case 0:
            imgMark.image = [UIImage imageNamed:@"menu_trending"];
            break;
            
        case 1:
            imgMark.image = [UIImage imageNamed:@"menu_logo"];
            break;
            
        case 2:
            imgMark.image = [UIImage imageNamed:@"menu_favorite"];
            break;
            
//        case 3:
//            imgMark.image = [UIImage imageNamed:@"menu_shop"];
//            break;
            
        case 3:
            imgMark.image = [UIImage imageNamed:@"menu_about"];
            break;
            
        case 4:
            imgMark.image = [UIImage imageNamed:@"menu_search"];
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
