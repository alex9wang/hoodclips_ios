//
//  AdmobNativeCell.m
//  hoodclips
//
//  Created by bongbong on 7/6/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#import "AdmobNativeCell.h"
#import "Constants.h"

@implementation AdmobNativeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadAdmobNativeExpress {
    self.naiveExpressAdView.adUnitID = ADMOB_NATIVE_AD_UNIT_ID;
    self.naiveExpressAdView.rootViewController = self.parentVC;
    
    GADRequest *request = [GADRequest request];
    [self.naiveExpressAdView loadRequest:request];
}
@end
