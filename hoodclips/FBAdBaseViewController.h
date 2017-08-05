//
//  FBAdBaseViewController.h
//  hoodclips
//
//  Created by great summit an on 6/12/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#ifndef FBAdBaseViewController_h
#define FBAdBaseViewController_h

#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <UIKit/UIKit.h>
#import "Analytics.h"

@interface FBAdBaseViewController : UIViewController


@property FBAdSize adSize;
@property (strong, nonatomic) IBOutlet FBAdView *adView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end


#endif /* FBAdBaseViewController_h */
