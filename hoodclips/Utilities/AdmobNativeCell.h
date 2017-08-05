//
//  AdmobNativeCell.h
//  hoodclips
//
//  Created by bongbong on 7/6/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface AdmobNativeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GADNativeExpressAdView *naiveExpressAdView;
@property UIViewController* parentVC;

-(void) loadAdmobNativeExpress;

@end
