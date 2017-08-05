//
//  VideoViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllVideoViewController.h"
#import "YTPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
//#import <FBAudienceNetwork/FBAudienceNetwork.h>
//#import "FBAdBaseViewController.h"
#import "MPInterstitialAdController.h"
#import "MPAdView.h"

@import GoogleMobileAds;

@class DisqusWebView;

@interface VideoViewController : UIViewController
{
    ServerParam         *param;
    BOOL                favorite;
}
@property (strong, nonatomic)IBOutlet UIWebView  *webView;
@property (strong, nonatomic)IBOutlet UILabel    *v_date;
@property (strong, nonatomic)IBOutlet UILabel    *v_views;
-(void)setParams : (ServerParam*) item;
-(IBAction) goBack:(id)sender;
- (IBAction)onFavorite:(id)sender;
- (IBAction)onShare:(id)sender;
- (IBAction)onTwitter:(id)sender;
- (IBAction)onFacebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UITextView *txtTitle
;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription
;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;
@property (strong, nonatomic) IBOutlet YTPlayerView *vYtPlayer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DisqusWebView *disqusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disqusHeight;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic,strong) MPMoviePlayerController* mc;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *adBannerView;
//@property FBAdView *adView;
@property (nonatomic) MPAdView *adView;


@property (nonatomic, retain) MPInterstitialAdController *interstitialMopubAd;
@property (nonatomic, strong) GADInterstitial *interstitialAdmob;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerAdmob;

@end
