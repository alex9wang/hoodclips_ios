//
//  ADTableViewCell.m
//  hoodclips
//
//  Created by zaitie-mac on 12/23/15.
//  Copyright © 2015 mrt. All rights reserved.
//

#import "ADTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Env.h"


@implementation ADTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

FBNativeAd *nativeAd;
- (void)showNativeAd:(UIViewController*)parentVC {
    _parentVC = parentVC;
    nativeAd = [[FBNativeAd alloc] initWithPlacementID:[Env adMobIdForNative]];
    nativeAd.delegate = self;
    [nativeAd loadAd];
}

#pragma FBNativeAdDelegate
- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    [_adImageView sd_setImageWithURL:nativeAd.icon.url placeholderImage:[UIImage imageNamed:@""]];
    _adTitleTextView.text = nativeAd.title;
    _adContentsTextView.text = nativeAd.body;
    _txtAdAction.text = nativeAd.callToAction;
    
    [nativeAd unregisterView];
    [nativeAd registerViewForInteraction:self.btnTrigger withViewController:_parentVC];
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
}

@end
