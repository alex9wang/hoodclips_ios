//
//  VideoViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "VideoViewController.h"
#import "AppDelegate.h"
#import "ShareThis.h"
#import <Social/Social.h>
#import "Constants.h"
#import "DisqusWebView.h"
#import "WebService.h"
#import <AVFoundation/AVFoundation.h>
#import "Env.h"
#import "ALInterstitialAd.h"

@interface VideoViewController() <YTPlayerViewDelegate, UIScrollViewDelegate, UIWebViewDelegate, MPInterstitialAdControllerDelegate, MPAdViewDelegate> {
    BOOL    bShowDescription;
    CGRect  frameDescription;
}

@end

@implementation VideoViewController
@synthesize  webView,v_date,v_views;
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
    //[super viewDidLoad];
    
    
    [super viewDidLoad];
    
    //self.adView = [[MPAdView alloc] initWithAdUnitId:MOPUB_BANNER_AD_UNIT_ID
    //                                            size:MOPUB_BANNER_SIZE];
    //self.adView.delegate = self;
    //self.adView.frame = CGRectMake((self.adBannerView.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
    //                              self.adBannerView.bounds.size.height - MOPUB_BANNER_SIZE.height,
    //                               MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    //[self.adBannerView addSubview:_adView];
    //[self.adView loadAd];

    [self initialize];
    //[self initializeMopub];
    [self initializeAdmob];//loadAdmobInterstitial];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)initialize {
    NSError *error = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory:AVAudioSessionCategoryPlayback
                    error:&error];
    if (!success) {
        // Handle error here, as appropriate
    }
    //set scroll View configure
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*3)];

    [self.txtTitle setText: [param getTitle]];
    [v_date setText: [param getDate]];
    [v_views setText: [param getViews]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[param getDescription] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [self.txtDescription setAttributedText:attrStr];
    bShowDescription = NO;
    _descriptionHeight.constant = 0;
    
    // configure play video
    if ([[param getUrl] containsString:@"youtube"]) {
        [self playYouTube];
    }
    else {
        [self playWebView];
    }

    if ([[param getfavourite] isEqualToString:@"0"]) {
        [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_off"] forState:UIControlStateNormal];
        favorite = NO;
    }
    else {
        [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_on"] forState:UIControlStateNormal];
        favorite = YES;
    }

    //set scroll View configure
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    // configure disqus
    [self.disqusView loadThread:[param getID]];
    self.disqusHeight.constant = 0;
    [self.disqusView.scrollView setScrollEnabled:NO];
    // set favorite button
}

- (void) playWebView {
    [self.playerView setHidden:NO];
    [self.vYtPlayer setHidden:YES];
    NSString *videoUrl = [param getUrl];
    if (![videoUrl containsString:@"/"])
    {
        videoUrl = [NSString stringWithFormat:@"http://www.hoodclips.com/uploads/videos/%@", videoUrl];
    }
    //NSString *htmlVideo = [NSString stringWithFormat: @"<video controls src=\"%@\" type=\"video/mp4\" webkit-playslinline></video>", videoUrl];
    
    webView.allowsInlineMediaPlayback = YES;
    webView.scrollView.scrollEnabled = NO;
    NSLog(@"videoUrl = %@", videoUrl);
    [self embedMVPlayer:videoUrl];
    //[webView loadHTMLString: htmlVideo baseURL: [NSURL URLWithString: htmlVideo]];

}

- (void) playYouTube {
    [self.playerView setHidden:YES];
    [self.vYtPlayer setHidden:NO];
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay" : @1,
                                 @"showinfo" : @0,
                                 @"rel" : @0,
                                 @"modestbranding" : @1,
                                 };
    
    [self.vYtPlayer loadWithVideoId:[param getyt_id] playerVars:playerVars];
    self.vYtPlayer.delegate = self;
    NSLog(@"videoUrl = %@", [param getUrl]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    APPDELEGATE.videoShowCount++;
    if (APPDELEGATE.videoShowCount % 3== 0) {
        //if ([ALInterstitialAd isReadyForDisplay])
        //    [ALInterstitialAd show];
        //[self showInterstitalMopubAd];
        [self showAdmobInterstitial];
    }
}

- (IBAction)onFavorite:(id)sender {
    NSMutableDictionary* requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setObject:[NSString stringWithFormat:@"%@", [[AppDelegate shardAppDeleget] getUUID]] forKey:POST_PARAM_DEVICEID];
    [requestParam setObject:[NSString stringWithFormat:@"%@", [param getID] ] forKey:POST_PARAM_VIDEOID];
    if (favorite == YES) {
        [requestParam setObject:POST_PARAM_WEBAPI_REMOVEFAVORITE forKey:post_param_webapi_mode_key];
    }
    else {
        [requestParam setObject:POST_PARAM_WEBAPI_ADDFAVORITE forKey:post_param_webapi_mode_key];
        
    }
    
    [WEBSERVICE postRequest:SUB_URL_ALLVIDEOS param:requestParam success:^(id responseObject) {
        NSDictionary *json = [responseObject objectFromJSONString];
        NSString* status = [NSString stringWithFormat:@"%@", [json objectForKey:@"status"]] ;
        if ([status isEqualToString:@"success"]) {
            favorite = !favorite;
            if (favorite) {
                [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_on"] forState:UIControlStateNormal];
                [param setfavourite:@"1"];
            }
            else {
                [_btnFavorite setImage:[UIImage imageNamed: @"ic_favorite_off"] forState:UIControlStateNormal];
                [param setfavourite:@"0"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    

}

- (IBAction)onShare:(id)sender {
    NSString *content = [NSString stringWithFormat:@"%@\r\n%@%@?vid=%@ #Hoodclips via @hoodclips.com", [param getTitle], WEBSITE_URL, WATCH_PHP, [param getID]];
    [SHARE_THIS setParentVC:self];
    [SHARE_THIS shareActivityControllerWithContent:content viewController:self];
}

- (IBAction)onTwitter:(id)sender {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:[param getyt_thumb]]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *url) {
        
                       SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                       NSString *content = [NSString stringWithFormat:@"%@\r\n%@%@?vid=%@ #Hoodclips via @hoodclips.com", [param getTitle], WEBSITE_URL, WATCH_PHP, [param getID]];
                       [twitterVC setInitialText:content];
                       [twitterVC addImage:image];
                       //[twitterVC addURL:[NSURL URLWithString:@"https://dev.twitter.com/docs"]];
                       NSString *hoodUrl = [NSString stringWithFormat:@"%@%@?vid=%@", WEBSITE_URL, WATCH_PHP, [param getID]];
                       
                       [twitterVC addURL:[NSURL URLWithString:hoodUrl]];
                        NSLog(@"Twitter hoodurl:%@", hoodUrl);
                        [self presentViewController:twitterVC animated:YES completion:nil];

        
                    }];
    }

- (IBAction)onFacebook:(id)sender {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:[param getyt_thumb]]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *url) {
                            
                            SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                            NSString *content = [NSString stringWithFormat:@"%@\r\n%@%@?vid=%@ #Hoodclips via @hoodclips.com", [param getTitle], WEBSITE_URL, WATCH_PHP, [param getID]];
                            [fbVC setInitialText:content];
                            [fbVC addImage:image];
                            //[fbVC addURL:[NSURL URLWithString:@"https://developers.facebook.com/ios"]];
                            NSString *hoodUrl = [NSString stringWithFormat:@"%@%@?vid=%@", WEBSITE_URL, WATCH_PHP, [param getID]];
                            [fbVC addURL:[NSURL URLWithString:hoodUrl]];
                            
                            NSLog(@"Facebook hoodurl:%@", hoodUrl);
                            [self presentViewController:fbVC animated:YES completion:nil];

                            
                            
                        }];
    }
-(void) setParams:(ServerParam *)item
{
    param = item;
//    [v_title setText: [param getTitle]];
//    [v_date setText: [param getDate]];
//    [v_views setText: [param getViews]];
//    [v_desc setText: [param getDescription]];
//    
//    NSString *htmlVideo = [NSString stringWithFormat: @"<video controls src=\"%@\" type=\"video/mp4\" webkit-playslinline></video>", [param getUrl]];
//    webView.allowsInlineMediaPlayback = YES;
//    [webView loadHTMLString: htmlVideo baseURL: [NSURL URLWithString: htmlVideo]];
}

- (void)embedMVPlayer:(NSString *)url {
    MPMoviePlayerController *player =
    [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:url]];
    [player prepareToPlay];
    self.mc = player;
    
    [self.playerView setNeedsLayout];
    [self.playerView layoutIfNeeded];
    
    [player.view setFrame: self.playerView.frame];  // player's frame must match parent's
    [self.mainView addSubview: player.view];
    // ...
    [player play];
    //NSLog(@"videoPlayer: %1f, %1f, %1f, %1f", videoPlayer.view.frame.origin.x, videoPlayer.view.frame.origin.x, videoPlayer.view.frame.size.width, videoPlayer.view.frame.size.height);
//    NSURL *movieURL = [NSURL URLWithString: url ];// @"http://166.62.122.222:3000/download/video/eee119c4-774e-4809-aa60-ced2bef21019.mp4"];
//    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
//    player.moviePlayer.fullscreen = YES;
//    player.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
//    player.view.frame = self.view.frame;
//    [self.view addSubview: player.view];
//    [player.moviePlayer play];
    //[self presentViewController:player animated:YES completion:nil];

}

-(void)embedYoutube:(NSString *)url {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
        color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, webView.frame.size.width-50, webView.frame.size.height-50];
    [webView loadHTMLString:html baseURL:nil];
}

//when the page loading is done, it would chek the current url and go to disqus home
-(void) refreshAndToDisqusComments:(NSString *)currentUrl {
    if ([currentUrl containsString:DISQUS_SUCCESS] ||
        [currentUrl containsString:DISQUS_TWITTER_COMPLETE] ||
         [currentUrl containsString:DISQUS_FACEBOOK_COMPLETE] ||
         [currentUrl containsString:DISQUS_GOOGLE_COMPLETE] ||
         [currentUrl containsString:DISQUS_NEXT_LOGIN]) {
        [self.disqusView loadThread:[param getID]];
    }
    else if ([currentUrl containsString:DISQUS_LOGOUT]) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)onTitleClicked:(id)sender {
    if ([_txtDescription.text length] != 0) {
        bShowDescription = !bShowDescription;
        _descriptionHeight.constant = bShowDescription == YES ? 80:0;
    }
    //[self showInterstitalMopubAd];
}

#pragma Youtube Delegate
-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self]; [self.vYtPlayer playVideo];
}

#pragma UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGFloat contentHeight = [aWebView scrollView].contentSize.height;
    NSString *result = [aWebView stringByEvaluatingJavaScriptFromString:@"document.height"];
    
   // NSUInteger height = [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.offsetHeight;"]] intValue];
    int height = (int)[result integerValue];
    //[self.disqusView intrinsicContentSize];
    
    self.disqusHeight.constant = 1;
    [self.disqusView setNeedsLayout];
    //CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    //CGSize fittingSize = [self.disqusView sizeThatFits:CGSizeZer
    //self.disqusView.scrollView.scrollEnabled = NO;
    
    self.disqusHeight.constant =  height + 20;//fittingSize.height;//self.disqusView.scrollView.contentSize.height;
    //CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//    [self.view setNeedsLayout];
//    [self.view setNeedsUpdateConstraints];
//    [self.view layoutIfNeeded];
    NSLog(@"size: %f - %i - %@ - %i",contentHeight, height, result, (int)self.disqusHeight.constant);
    NSString *currentURL = aWebView.request.URL.absoluteString;
    NSLog(@"url: %@", currentURL);
    [self refreshAndToDisqusComments:currentURL];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *currentURL = aWebView.request.URL.absoluteString;
    if ([currentURL containsString:DISQUS_EMBED_PROFILE]){
        return NO;
    }
    else {
        return YES;
    }

}

#pragma mark - Mopub integration

- (void) initializeMopub {
    self.interstitialMopubAd = [MPInterstitialAdController
                                interstitialAdControllerForAdUnitId:MOPUB_INTERSTITIAL_AD_UNIT_ID];
    
    self.interstitialMopubAd.delegate = self;
    // Fetch the interstitial ad.
    [self.interstitialMopubAd loadAd];
}

- (void) showInterstitalMopubAd {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"showInterstitialAd" object:self];
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

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)initializeAdmob {
    
    int playingCount = APPDELEGATE.videoShowCount + 1;
    if (playingCount % 3 == 0) {
        [self loadAdmobInterstitial];
    }
    [self loadAdmobBanner];
}
- (void)loadAdmobInterstitial {
    self.interstitialAdmob =
    [[GADInterstitial alloc] initWithAdUnitID:ADMOB_INTERSTITIAL_AD_UNIT_ID];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    //request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
    [self.interstitialAdmob loadRequest:request];
}

- (void)showAdmobInterstitial {
    if (self.interstitialAdmob.isReady) {
        [self.interstitialAdmob presentFromRootViewController:self.parentViewController];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (void)loadAdmobBanner {
    self.bannerAdmob.adUnitID = ADMOB_BANMNER_AD_UNIT_ID;
    self.bannerAdmob.rootViewController = self;
    self.bannerAdmob.adSize = kGADAdSizeSmartBannerPortrait;
    //[self.adBannerView addSubview:_bannerAdmob];
    [self.bannerAdmob loadRequest:[GADRequest request]];
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
