//
//  MPNativeAdView.m
//  hoodclips
//
//  Created by bongbong on 6/24/16.
//  Copyright © 2016 mrt. All rights reserved.
//

#import "MPNativeAdView.h"

@implementation MPNativeAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initializeSubviews];
    }
    
    return self;
}

/*- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //We are in the storyboard code path. Initialize from the xib.
        self = [self initializeSubviews];
        
        //Here, you can load properties that you wish to expose to the user to set in a storyboard; e.g.:
        //self.backgroundColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"backgroundColor"];
    }
    
    return self;
}*/

-(id)initializeSubviews {
    id view =   [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    return view;
}

#pragma <MPNativeRendering>

- (UILabel *)nativeMainTextLabel
{
    return self.adContentsTextView;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.adTitleTextView;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.txtAdAction;
}

- (UIImageView *)nativeMainImageView
{
    return self.adImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyIconImageView;
}

@end
