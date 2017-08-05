//
//  FBAdBaseViewController.m
//  hoodclips
//
//  Created by great summit an on 6/12/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#import "FBAdBaseViewController.h"
#import "UIUtils.h"
#import "Env.h"
#import "AppDelegate.h"

@interface FBAdBaseViewController() <FBAdViewDelegate> {
    FBAdSize _adSize;
    NSLayoutConstraint *_adHeightConstraint;
}
@end

@implementation FBAdBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
    if (APPDELEGATE.isPurchased == 1 && _adView != nil) {
        [self.view layoutIfNeeded];
        _adHeightConstraint.constant = _adSize.size.height;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _adSize = kFBAdSize320x50;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (APPDELEGATE.isPurchased == 0) {
        _adView = [[FBAdView alloc] initWithPlacementID:[Env adMobIdForBanner]
                                                 adSize:kFBAdSize320x50
                                     rootViewController:self];
        
        _adView.backgroundColor = RGB(230, 230, 230);
        [self.view addSubview:_adView];
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
                                      constant:_adSize.size.height];
        [self.view addConstraint:_adHeightConstraint];
        
        [_adView loadAd];
    }
}

- (FBAdSize)adSize {
    return _adSize;
}

- (void)setAdSize:(FBAdSize)adSize {
    _adSize = adSize;
    if(_adHeightConstraint.constant != 0) {
        _adHeightConstraint.constant = _adSize.size.height;
    }
}

#pragma FBAdViewDelegate
- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
        [self.view layoutIfNeeded];
        _adHeightConstraint.constant = _adSize.size.height;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    });
}

- (void)adViewDidLoad:(FBAdView *)adView
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

@end
