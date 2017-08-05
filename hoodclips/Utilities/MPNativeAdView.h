//
//  MPNativeAdView.h
//  hoodclips
//
//  Created by bongbong on 6/24/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"


@interface MPNativeAdView : UIView <MPNativeAdRendering>
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *adContentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *txtAdAction;
@property (weak, nonatomic) IBOutlet UIButton *btnTrigger;
@property (weak, nonatomic) IBOutlet UIImageView *privacyIconImageView;


@end
