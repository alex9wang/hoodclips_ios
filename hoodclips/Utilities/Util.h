//
//  Util.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define UTIL        [Util sharedInstant]

@interface Util : NSObject

+ (id)sharedInstant;
- (BOOL) validEmail:(NSString*) emailString;
- (void)showMessage:(NSString *)message;
- (void)openBrownserWithLink:(NSString *)link;
- (void)showHub:(BOOL)isShow;
- (NSString *)getAppVerison;
- (UIColor*)transformedColor:(NSString*)strColor;

- (NSString *) timeLeftSinceDate:(NSDate *)dateT;
- (void) setHtml: (UILabel*)label  html:(NSString*) html;
@end
