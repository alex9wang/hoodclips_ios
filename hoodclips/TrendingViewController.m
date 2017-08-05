//
//  FavoriteViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "TrendingViewController.h"
#import "Constants.h"
#import "Utilities/CustomTableViewCell.h"
#include "AppDelegate.h"
#import "Util.h"
#import "WebService.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "UIViewController+SlideMenu.h"
#import "Env.h"
#import "UIUtils.h"
#import "MBProgressHUD.h"


@interface TrendingViewController()  {
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
}

@property (nonatomic, assign) NSInteger nWidth;
@property (nonatomic, assign) NSInteger nHeight;
@end

@implementation TrendingViewController
@synthesize  table;

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
    // Do any additional setup after loading the view.
    [UIUTIL setNavigation:self withTitle:@"TRENDING VIDEOS" withImageName:@"icon_trending"];
    
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [table reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"show"]) {
//        NSString* strName = (NSString*)sender;
//        SubCategoryViewController* target = [segue destinationViewController];
//        target.strCategoryTitle = strName;
//        [Analytics sendEvent:@"SubCategory"
//                       label:strName];
    }
}

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSLog(@"Landscape");
    }
    else {
        NSLog(@"Portrait");
    }
    
    [table reloadData];
}

-(void)initialize{
    serverParams = [[NSMutableArray alloc] init];
    isRecevied = FALSE;
    currentPageNum = 0;
    topRefreshControl = [[UIRefreshControl alloc]init];
    [topRefreshControl addTarget:self action:@selector(topRefreshTable) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:topRefreshControl];
    
    refreshControl = [[UIRefreshControl alloc]init];
    self.table.bottomRefreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    // 1. check network status
    [WEBSERVICE checkNetworkStatus:self];
    [self refreshTable];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return serverParams.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(currentMaxIndex < indexPath.row)
        currentMaxIndex = indexPath.row;
    
    CustomTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"CustomTableViewCell"];
    }
    ServerParam* item = [serverParams objectAtIndex: [indexPath row]];
    [cell setThumbPath: [item getyt_thumb]];
    [cell setDecription:[item getTitle]];
    [cell setViews: [item getViews]];
    [cell setDate: [item getDate]];
    [cell setFeatured: [item getfavourite]];
    [cell setVideoId:[item getID]];
    [cell setItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerParam* param = [serverParams objectAtIndex: [indexPath row]];
    VideoViewController *videoView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
    [videoView setParams:param];
    [self.navigationController pushViewController:videoView animated:YES];
}

-(void)getListFromServer:(NSInteger)pageNum{
    [UTIL showHub:YES];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@", @(pageNum)] forKey:post_param_page_num_key];
    [param setObject:[NSString stringWithFormat:@"%@", @(post_param_limit_value)] forKey:post_param_limit_key];
    [param setObject:post_param_webapi_mode_value forKey:post_param_webapi_mode_key];
    isRecevied = FALSE;
    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:param success:^(id responseObject) {
        [UTIL showHub:NO];
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]] ;
        if ([status isEqualToString:@"success"]) {
            
            NSMutableArray *data = [json objectForKey: @"data"];
            if (data != nil)
            {
                for(NSInteger index = 0 ; index < data.count ; index ++)
                {
                    NSDictionary* item =  data[index];
                    ServerParam* param = [[ServerParam alloc] init];
                    [param setyt_thumb: [item objectForKey:@"yt_thumb"]];
                    NSString* views = [NSString stringWithFormat:@"%@%@", [item objectForKey: @"site_views"], @" Views"];
                    [param setViews: views];
                    [param setID: [item objectForKey: @"id"]];
                    [param setDesc: [item objectForKey: @"video_desc"]];
                    [param setTitle: [item objectForKey: @"video_title"]];
                    [param setCategory: [item objectForKey: @"category"]];
                    [param setUrl: [item objectForKey: @"video_url"]];
                    [param setFeatured: [item objectForKey: @"featured"]];
                    [param setDate: [item objectForKey: @"date_added"]];
                    [param setfavourite:[item objectForKey: @"favourite"]];
                    [param setyt_id:[item objectForKey: @"yt_id"]];
                    [serverParams insertObject:param atIndex:(pageNum * post_param_limit_value + index)];
                }
                isRecevied = TRUE;
                [self.table reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [UTIL showHub:NO];
    }];
}

- (void)refreshTable {
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@", @(currentPageNum)] forKey:post_param_page_num_key];
    [param setObject:[NSString stringWithFormat:@"%@", @(post_param_limit_value)] forKey:post_param_limit_key];
    [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_TRENDING];
    [param setObject:post_param_webapi_mode_value forKey:post_param_webapi_mode_key];
    [param setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    
    isRecevied = FALSE;
    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:param success:^(id responseObject) {
        [refreshControl endRefreshing];
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]] ;
        if ([status isEqualToString:@"success"]) {
            
            NSMutableArray *data = [json objectForKey: @"data"];
            if (data != nil && data.count > 0)
            {
                for(NSInteger index = 0 ; index < data.count ; index ++)
                {
                    NSDictionary* item =  data[index];
                    ServerParam* param = [[ServerParam alloc] init];
                    [param setyt_thumb: [item objectForKey:@"yt_thumb"]];
                    NSString* views = [NSString stringWithFormat:@"%@%@", [item objectForKey: @"site_views"], @" Views"];
                    [param setViews: views];
                    [param setID: [item objectForKey: @"id"]];
                    [param setDesc: [item objectForKey: @"video_desc"]];
                    [param setTitle: [item objectForKey: @"video_title"]];
                    [param setCategory: [item objectForKey: @"category"]];
                    [param setUrl: [item objectForKey: @"video_url"]];
                    [param setFeatured: [item objectForKey: @"featured"]];
                    [param setDate: [item objectForKey: @"date_added"]];
                    [param setfavourite:[item objectForKey: @"favourite"]];
                    [param setyt_id:[item objectForKey: @"yt_id"]];
                    [serverParams insertObject:param atIndex:(currentPageNum * post_param_limit_value + index)];
                }
                currentPageNum++;
                isRecevied = TRUE;
                [self.table reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [refreshControl endRefreshing];
    }];
}

- (void)topRefreshTable {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@", @"0"] forKey:post_param_page_num_key];
    [param setObject:[NSString stringWithFormat:@"%@", @(post_param_limit_value)] forKey:post_param_limit_key];
    [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_TRENDING];
    [param setObject:post_param_webapi_mode_value forKey:post_param_webapi_mode_key];
    [param setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    
    isRecevied = FALSE;
    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:param success:^(id responseObject) {
        [topRefreshControl endRefreshing];
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]];
        if ([status isEqualToString:@"success"]) {
            [serverParams removeAllObjects];
            NSMutableArray *data = [json objectForKey: @"data"];
            if (data != nil && data.count > 0)
            {
                for(NSInteger index = 0 ; index < data.count ; index ++)
                {
                    NSDictionary* item =  data[index];
                    ServerParam* param = [[ServerParam alloc] init];
                    [param setyt_thumb: [item objectForKey:@"yt_thumb"]];
                    NSString* views = [NSString stringWithFormat:@"%@%@", [item objectForKey: @"site_views"], @" Views"];
                    [param setViews: views];
                    [param setID: [item objectForKey: @"id"]];
                    [param setDesc: [item objectForKey: @"video_desc"]];
                    [param setTitle: [item objectForKey: @"video_title"]];
                    [param setCategory: [item objectForKey: @"category"]];
                    [param setUrl: [item objectForKey: @"video_url"]];
                    [param setFeatured: [item objectForKey: @"featured"]];
                    [param setDate: [item objectForKey: @"date_added"]];
                    [param setfavourite:[item objectForKey: @"favourite"]];
                    [param setyt_id:[item objectForKey: @"yt_id"]];
                    [serverParams insertObject:param atIndex:(index)];
                }
                isRecevied = TRUE;
                [self.table reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [topRefreshControl endRefreshing];
    }];
}



@end

