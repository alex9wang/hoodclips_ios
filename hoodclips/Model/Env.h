//
//  Env.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Env : NSObject

+ (NSString*)adMobIdForBanner;
//+ (NSString*)adMobIdForInterstitial;
+ (NSString*)adMobIdForNative;
+ (NSString*)analyticsTrackingId;

@end
