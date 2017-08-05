//
//  Env.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "Env.h"

//iOS Banner:
//ca-app-pub-7913152423620879/2176591540
//iOS Video
//ca-app-pub-7913152423620879/5130057945
//iOS Native
//ca-app-pub-7913152423620879/2036990744

@implementation Env

+ (NSString*)adMobIdForBanner {
//    return @"ca-app-pub-9184026071571490/8958457397";
//    return @"ca-app-pub-7913152423620879/2176591540";
    return @"1569665693333635_1569805803319624";
}

//+ (NSString*)adMobIdForInterstitial {
////    return @"ca-app-pub-9184026071571490/1435190594";
//    return @"ca-app-pub-7913152423620879/5130057945";
//}

+ (NSString*)adMobIdForNative {
    return @"1569665693333635_1569805953319609";
}

+ (NSString*)analyticsTrackingId {
    return @"UA-57953802-8";
}


@end
