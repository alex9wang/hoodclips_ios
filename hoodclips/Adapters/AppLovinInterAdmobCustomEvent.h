//
//  AppLovinInterAdmobCustomEvent.h
//  hoodclips
//
//  Created by bongbong on 7/7/16.
//  Copyright © 2016 mrt. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import "ALAdService.h"
#import "ALInterstitialAd.h"

@interface AppLovinInterAdmobCustomEvent : NSObject <GADCustomEventInterstitial, ALAdLoadDelegate, ALAdDisplayDelegate>

@property (strong, atomic) ALAd* appLovinAd;

@end
