//
//  BaseViewController.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Analytics.h"

@import GoogleMobileAds;

@interface BaseViewController : GAITrackedViewController


@property GADAdSize adSize;
@property (strong, nonatomic) IBOutlet GADBannerView *adView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
