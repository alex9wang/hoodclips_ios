//
//  BaseViewController.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "BaseViewController.h"
#import "UIUtils.h"
#import "Env.h"
#import "AppDelegate.h"

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
@interface BaseViewController() <GADBannerViewDelegate>
{
    GADAdSize _adSize;
    NSLayoutConstraint *_adHeightConstraint;
}
@end
#endif

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
    if (APPDELEGATE.isPurchased == 1 && _adView != nil) {
        [self.view layoutIfNeeded];
        _adHeightConstraint.constant = CGSizeFromGADAdSize(_adSize).height;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
   
}


#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
- (void)awakeFromNib {
    [super awakeFromNib];
    _adSize = kGADAdSizeBanner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (APPDELEGATE.isPurchased == 0) {
        if(_adView == nil) {
            _adView = [[GADBannerView alloc] initWithAdSize:_adSize];
            _adView.backgroundColor = RGB(230, 230, 230);
            [self.view addSubview:_adView];
        }
        else {
            _adView.adSize = _adSize;
        }
        
        _adView.adUnitID = [Env adMobIdForBanner];;
        _adView.rootViewController = self;
        _adView.delegate = self;
        
        [self.view removeConstraints:[self.view constraints]];
        
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_adView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"contentView":_contentView}]];
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[adView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"adView":_adView}]];
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView][adView]"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"contentView":_contentView,
                                                           @"adView":_adView}]];
        _adHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_adView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:CGSizeFromGADAdSize(_adSize).height];
        [self.view addConstraint:_adHeightConstraint];
        
        [self requestAd];
    }
}

- (GADAdSize)adSize {
    return _adSize;
}

- (void)setAdSize:(GADAdSize)adSize {
    _adSize = adSize;
    if(_adHeightConstraint.constant != 0) {
        _adHeightConstraint.constant = CGSizeFromGADAdSize(_adSize).height;
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
        [self.view layoutIfNeeded];
        _adHeightConstraint.constant = CGSizeFromGADAdSize(_adSize).height;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        [self performSelector:@selector(requestAd) withObject:nil afterDelay:60.0];
    });
}

- (void)adViewDidReceiveAd:(GADBannerView *)view;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        if(_adHeightConstraint.constant == 0) return;
        NSLog(@"Ad Received");
        if (APPDELEGATE.isPurchased == 0) {
            [self.view layoutIfNeeded];
            _adHeightConstraint.constant = 0;
            [UIView animateWithDuration:0.4
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }];
        }
    });
    
}

-(void) requestAd
{
    GADRequest *request;
    _adView.adSize = _adSize;
    //request.testDevices = @[ GAD_SIMULATOR_ID ];
    [_adView loadRequest:request];
}

#endif

@end
