//
//  Analytics.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <Foundation/Foundation.h>

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#endif

@class BaseViewController;

@interface Analytics : NSObject

+ (void)init;
+ (void)sendScreenName:(NSString*)screenName;
+ (void)sendEvent:(NSString*)action
            label:(NSString*)label;

@end
