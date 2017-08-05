//
//  AllVideoViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "AllVideoViewController.h"
#import "Constants.h"
#import "Utilities/CustomTableViewCell.h"
#include "AppDelegate.h"
#import "Util.h"
#import "WebService.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "UIUtils.h"
#import "Env.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPTableViewAdPlacer.h"
#import "MPClientAdPositioning.h"
#import "MPNativeAdConstants.h"
#import "MPStaticNativeAdRendererSettings.h"
#import "MPStaticNativeAdRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import <CoreLocation/CoreLocation.h>
#import "MOPUBNativeVideoAdRenderer.h"
#import "MOPUBNativeVideoAdRendererSettings.h"
#import "MPNativeAdView.h"
#import "AdmobNativeCell.h"
#import "ADTableViewCell.h"

#define AD_ROW_COUNT 5

@import GoogleMobileAds;

@interface AllVideoViewController () <MPTableViewAdPlacerDelegate>

@property (nonatomic, strong) MPTableViewAdPlacer *placer;

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ServerParam
-(void)setfavourite : (NSString*) nums
{
    favourite = nums;
}
-(void)setyt_id : (NSString*) _id
{
    yt_id = _id;
}
-(void)setyt_thumb : (NSString*) path
{
    yt_thumb = path;
}
-(void)setViews : (NSString*) views
{
    site_views = views;
}
-(void)setID : (NSString*) iden
{
    identifier = iden;
}
-(void)setDesc : (NSString*) desc
{
    video_desc = desc;
}
-(void)setTitle : (NSString*) title
{
    video_title = title;
}
-(void)setCategory : (NSString*) cate
{
    category = cate;
}
-(void)setUrl : (NSString*) url
{
    video_url = url;
}
-(void)setFeatured : (NSString*) feature
{
    featured = feature;
}
-(void)setDate : (NSString*) date
{
    date_added = date;
}

-(NSString*)getfavourite
{
    return  favourite;
}

-(NSString*)getyt_id
{
    return yt_id;
}
-(NSString*)getyt_thumb
{
    return yt_thumb;
}
-(NSString*)getViews
{
    return site_views;
}
-(NSString*)getID
{
    return identifier;
}
-(NSString*)getDescription
{
    return video_desc;
}
-(NSString*)getTitle
{
    return video_title;
}
-(NSString*)getCategory
{
    return category;
}
-(NSString*)getUrl
{
    return video_url;
}
-(NSString*)getFeatured
{
    return featured;
}
-(NSString*)getDate
{
    return date_added;
}
@end

@implementation AllVideoViewController
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
    if (viewType == 0) {
        [UIUTIL setNavigation:self withTitle:@"TRENDING VIDEOS" withImageName:@"icon_trending"];
    } else if (viewType == 1) {
        [UIUTIL setNavigation:self withTitle:@"FAVORITES VIDEO" withImageName:@"icon_favorites"];
    } else {
        [UIUTIL setNavigation:self withTitle:@"ALL VIDEOS" withImageName:@"icon_logo"];
    }
    
    [self initialize];
    //[self initializeMopub];
    //[self setupAdPlacer];
    [UTIL showHub:YES];

    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.table setNeedsLayout];
    [self.view setNeedsDisplay];
    [table mp_reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

-(void)initialize{
    
    serverParams = [[NSMutableArray alloc] init];
    isRecevied = FALSE;
    currentPageNum = 0;
    //top refresh
    topRefreshControl = [[UIRefreshControl alloc] init];
    [topRefreshControl addTarget:self action:@selector(topRefreshTable) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:topRefreshControl];
    //bottom refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.table.bottomRefreshControl =refreshControl;
    // 1. check network status
    [WEBSERVICE checkNetworkStatus:self];
    [self refreshTable];
    //self.table.multipleTouchEnabled = NO;
    [self loadAdmobBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}// Default is 1 if not implemented

- (void)setViewType:(int)type {
    viewType = type;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (APPDELEGATE.isPurchased == 0) {
        if (indexPath.row % AD_ROW_COUNT != AD_ROW_COUNT - 1) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                return 200;
            } else {
                return 150;
            }
        } else {
            return 116;
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return 200;
        } else {
            return 150;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (APPDELEGATE.isPurchased == 0) {
        if(section == 0)
            return serverParams.count + serverParams.count / AD_ROW_COUNT;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (APPDELEGATE.isPurchased == 0) {
        if (indexPath.row % AD_ROW_COUNT != AD_ROW_COUNT - 1) {
            int index = (int)indexPath.row - (int)(indexPath.row / AD_ROW_COUNT);
            CustomTableViewCell *cell  = [tableView mp_dequeueReusableCellWithIdentifier:@"CustomTableViewCell" forIndexPath:indexPath];
            if(cell == nil)
            {
                cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"CustomTableViewCell"];
            }
            NSLog(@"index of row : %d", index);
            ServerParam* item = [serverParams objectAtIndex: index];
            [cell setThumbPath: [item getyt_thumb]];
            [cell setDecription:[item getTitle]];
            [cell setViews: [item getViews]];
            [cell setDate: [item getDate]];
            [cell setFeatured: [item getfavourite]];
            [cell setVideoId:[item getID]];
            [cell setItem: item];
            return cell;
        } else {
            /*AdmobNativeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdmobNativeCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[AdmobNativeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AdmobNativeCell"];
            }
            [cell setParentVC:self];
            [cell loadAdmobNativeExpress];*/
            ADTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADTableViewCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ADTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ADTableViewCell"];
            }
            [cell showNativeAd:self];
            
            return cell;
        }
    } else {
        int index = (int)indexPath.row;
        CustomTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell" forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"CustomTableViewCell"];
        }
        ServerParam* item = [serverParams objectAtIndex: index];
        [cell setThumbPath: [item getyt_thumb]];
        [cell setDecription:[item getTitle]];
        [cell setViews: [item getViews]];
        [cell setDate: [item getDate]];
        [cell setFeatured: [item getfavourite]];
        [cell setVideoId:[item getID]];
        [cell setItem: item];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = -1;
    if (APPDELEGATE.isPurchased == 0) {
        if (indexPath.row % AD_ROW_COUNT != AD_ROW_COUNT - 1) {
            index = (int)indexPath.row - (int)(indexPath.row / AD_ROW_COUNT);
 
        }
    } else {
        index = (int)indexPath.row;
    }
    
    if (index != -1) {
        ServerParam* param = [serverParams objectAtIndex: index];
        VideoViewController *videoView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
        [videoView setParams:param];
        [self.navigationController pushViewController:videoView animated:YES];
    }
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
                [self.table mp_reloadData];
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
    [param setObject:post_param_webapi_mode_value forKey:post_param_webapi_mode_key];
    [param setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    
    if (viewType == 0) {
        [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_TRENDING];
    } else if (viewType == 1) {
        [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_FAVORITE];
    }
    
    isRecevied = FALSE;
    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:param success:^(id responseObject) {
        [refreshControl endRefreshing];
        [UTIL showHub:NO];
        
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]];
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
                
                [self.table mp_reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [UTIL showHub:NO];
        [refreshControl endRefreshing];
    }];
}

- (void)topRefreshTable {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%@", @"0"] forKey:post_param_page_num_key];
    [param setObject:[NSString stringWithFormat:@"%@", @(post_param_limit_value)] forKey:post_param_limit_key];
    [param setObject:post_param_webapi_mode_value forKey:post_param_webapi_mode_key];
    [param setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    if (viewType == 0) {
        [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_TRENDING];
    } else if (viewType == 1) {
        [param setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:POST_PARAM_WEBAPI_FAVORITE];
    }
    
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
                [self.table mp_reloadData];
            }
            
        }
    } failure:^(NSError *error) {
        [topRefreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"y=%2.f height=%2.f --- total:%2.f", scrollView.contentOffset.y, scrollView.frame.size.height, scrollView.contentSize.height);
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
        if (isRecevied == YES) {
            [refreshControl beginRefreshing];
            [self refreshTable];
        }
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self.table]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

#pragma mark - AdPlacer

- (void)setupAdPlacer
{
    // Create a targeting object to serve better ads.
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    //targeting.location = [[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4175];
    targeting.desiredAssets = [NSSet setWithObjects:kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey, kAdDAAIconImageKey, nil];
    
    // Create and configure a renderer configuration.
    
    // Static native ads
    MPStaticNativeAdRendererSettings *nativeAdSettings = [[MPStaticNativeAdRendererSettings alloc] init];
    nativeAdSettings.renderingViewClass = [MPNativeAdView class];
    nativeAdSettings.viewSizeHandler = ^(CGFloat maximumWidth) {
        return CGSizeMake(maximumWidth, 116.0f);
    };
    
    MPNativeAdRendererConfiguration *nativeAdConfig = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:nativeAdSettings];
    
    // Native video ads. You don't need to create nativeVideoAdSettings and nativeVideoConfig unless you are using native video ads.
    //MOPUBNativeVideoAdRendererSettings *nativeVideoAdSettings = [[MOPUBNativeVideoAdRendererSettings alloc] init];
    //nativeVideoAdSettings.renderingViewClass = [MPNativeVideoTableViewAdPlacerView class];
    //nativeVideoAdSettings.viewSizeHandler = ^(CGFloat maximumWidth) {
    //    return CGSizeMake(maximumWidth, 312.0f);
    //};
    //MPNativeAdRendererConfiguration *nativeVideoConfig = [MOPUBNativeVideoAdRenderer rendererConfigurationWithRendererSettings:nativeVideoAdSettings];
    
    // Create a table view ad placer that uses server-side ad positioning.
    self.placer = [MPTableViewAdPlacer placerWithTableView:self.table viewController:self rendererConfigurations:@[nativeAdConfig]];
    
    // If you wish to use client-side ad positioning rather than configuring your ad unit on the
    // MoPub website, comment out the line above and use the code below instead.
    
    // Create an ad positioning object and register the index paths where ads should be displayed.
    /*
     MPClientAdPositioning *positioning = [MPClientAdPositioning positioning];
     [positioning addFixedIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
     [positioning addFixedIndexPath:[NSIndexPath indexPathForRow:30 inSection:0]];
     [positioning addFixedIndexPath:[NSIndexPath indexPathForRow:60 inSection:0]];
     [positioning addFixedIndexPath:[NSIndexPath indexPathForRow:90 inSection:0]];
     [positioning enableRepeatingPositionsWithInterval:10];
     self.placer = [MPTableViewAdPlacer placerWithTableView:self.tableView viewController:self adPositioning:positioning rendererConfigurations:@[nativeAdConfig, nativeVideoConfig]];
     */
    
    self.placer.delegate = self;
    // Load ads (using a test ad unit ID). Feel free to replace this ad unit ID with your own.
    [self.placer loadAdsForAdUnitID:MOPUB_NATIVE_AD_UNIT_ID targeting:targeting];
}

#pragma mark - UITableViewAdPlacerDelegate

- (void)nativeAdWillPresentModalForTableViewAdPlacer:(MPTableViewAdPlacer *)placer
{
    NSLog(@"Table view ad placer will present modal.");
}

- (void)nativeAdDidDismissModalForTableViewAdPlacer:(MPTableViewAdPlacer *)placer
{
    NSLog(@"Table view ad placer did dismiss modal.");
}

- (void)nativeAdWillLeaveApplicationFromTableViewAdPlacer:(MPTableViewAdPlacer *)placer
{
    NSLog(@"Table view ad placer will leave application.");
}

#pragma mark - Mopub integration

- (void) initializeMopub {
    self.interstitialMopubAd = [MPInterstitialAdController
                                interstitialAdControllerForAdUnitId:MOPUB_INTERSTITIAL_AD_UNIT_ID];
    
    self.interstitialMopubAd.delegate = self;
    // Fetch the interstitial ad.
    [self.interstitialMopubAd loadAd];
    
    //register notification for show Interstitial
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showInterstitalMopubAd:) name:@"showInterstitialAd" object:nil];
}

- (void) showInterstitalMopubAd:(NSNotification*)notification {
    
    if (self.interstitialMopubAd.ready) {
        [self.interstitialMopubAd showFromViewController:self];
    }
}

// delegate callback
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"Mopub Interstital did load.");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"Mopub Intersititial did fail to load");
}
- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"Mopub Intersititial will appear");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial{
    NSLog(@"Mopub Intersititial did appear");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial{
    NSLog(@"Mopub Intersititial will disappear");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial{
    NSLog(@"Mopub Intersititial did disappear");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"Mopub Intersititial did expire");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"Mopub Intersititial did Receive tab event");
}


- (void)loadAdmobBanner {
    self.admobBanner.adUnitID = ADMOB_BANMNER_AD_UNIT_ID;
    self.admobBanner.rootViewController = self;
    self.admobBanner.adSize = kGADAdSizeSmartBannerPortrait;
    //[self.admobBanner addSubview:_admobBanner];
    [self.admobBanner loadRequest:[GADRequest request]];
    //self.adView = [[MPAdView alloc] initWithAdUnitId:MOPUB_BANNER_AD_UNIT_ID
    //                                            size:MOPUB_BANNER_SIZE];
    //self.adView.delegate = self;
    //self.adView.frame = CGRectMake((self.adBannerView.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
    //                              self.adBannerView.bounds.size.height - MOPUB_BANNER_SIZE.height,
    //                               MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    //[self.adBannerView addSubview:_adView];
    //[self.adView loadAd];
    
    
}

@end
