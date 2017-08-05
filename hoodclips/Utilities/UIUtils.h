//
//  UIUtils.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIUTIL        [UIUtils sharedInstant]

#define RGB(r, g, b) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha: a]

@interface UIUtils : NSObject

+ (id)sharedInstant;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (void)setNavigation:(UIViewController*)vc withTitle:(NSString *)title withImageName:(NSString*)imageName;

@end
