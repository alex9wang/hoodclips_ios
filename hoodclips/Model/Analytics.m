//
//  Analytics.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "Analytics.h"
#import "Env.h"

@implementation Analytics

+ (void)init {
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
//    [[GAI sharedInstance] trackerWithTrackingId:[Env analyticsTrackingId]];
#endif
}

+ (void)sendScreenName:(NSString*)screenName {
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
#endif
}


+ (void)sendEvent:(NSString*)action
            label:(NSString*)label {
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Navigate"
                                                               action:action
                                                                label:label
                                                                value:@(1)] build]];
#endif
}

@end
