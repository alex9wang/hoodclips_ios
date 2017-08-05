//
//  AllVideoViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPInterstitialAdController.h"
@import GoogleMobileAds;

@interface ServerParam : NSObject
{
    NSString        *site_views;
    NSString        *identifier;
    NSString        *video_desc;
    NSString        *video_title;
    NSString        *category;
    NSString        *video_url;
    NSString        *featured;
    NSString        *date_added;
    NSString        *yt_id;
    NSString        *favourite;
    NSString        *yt_thumb;
}
-(void)setyt_thumb : (NSString*) path;
-(void)setViews : (NSString*) views;
-(void)setID : (NSString*) iden;
-(void)setDesc : (NSString*) desc;
-(void)setTitle : (NSString*) title;
-(void)setCategory : (NSString*) cate;
-(void)setUrl : (NSString*) url;
-(void)setFeatured : (NSString*) featured;
-(void)setDate : (NSString*) date;
-(void)setyt_id : (NSString*) yt_id;
-(void)setfavourite : (NSString*) nums;

-(NSString*)getfavourite;
-(NSString*)getyt_id;
-(NSString*)getyt_thumb;
-(NSString*)getViews;
-(NSString*)getID;
-(NSString*)getDescription;
-(NSString*)getTitle;
-(NSString*)getCategory;
-(NSString*)getUrl;
-(NSString*)getFeatured;
-(NSString*)getDate;
@end

@interface AllVideoViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MPInterstitialAdControllerDelegate>
{
    NSMutableArray      *serverParams;
    NSInteger           currentPageNum;
    NSInteger           currentMaxIndex;
    NSInteger           currentMinIndex;
    BOOL                isRecevied;
    UIRefreshControl*    refreshControl;
    UIRefreshControl*    topRefreshControl;
    
    int             viewType;
}

@property(nonatomic, strong) IBOutlet UITableView *table;

- (void)setViewType:(int)type;
@property (nonatomic, retain) MPInterstitialAdController *interstitialMopubAd;

@property (weak, nonatomic) IBOutlet GADBannerView *admobBanner;

@end
