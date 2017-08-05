//
//  ADTableViewCell.h
//  hoodclips
//
//  Created by zaitie-mac on 12/23/15.
//  Copyright © 2015 mrt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FBAudienceNetwork;


@interface ADTableViewCell : UITableViewCell <FBNativeAdDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *adContentsTextView;
@property (weak, nonatomic) IBOutlet UILabel *txtAdAction;
@property (weak, nonatomic) IBOutlet UIButton *btnTrigger;
@property (weak, nonatomic) IBOutlet UIImageView *privacyIconImageView;

@property UIViewController* parentVC;

- (void)showNativeAd:(UIViewController*)parentVC;

@end
