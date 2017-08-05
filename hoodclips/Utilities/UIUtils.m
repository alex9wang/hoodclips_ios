//
//  UIUtils.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "UIUtils.h"
#import "UIViewController+SlideMenu.h"

static UIUtils *_uiutil;

@implementation UIUtils

+ (UIUtils*)sharedInstant {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uiutil = [[UIUtils alloc]init];
    });
    return _uiutil;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setNavigation:(UIViewController*)vc withTitle:(NSString *)title withImageName:(NSString*)imageName {
    [vc setNavigationBarItem];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentLeft;
    [iv addSubview:lb];
    lb.text = title;
    lb.textColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    vc.navigationItem.titleView = iv;
}

- (void) myAction{
}


@end
