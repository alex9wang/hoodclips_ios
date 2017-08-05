//
//  Util.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static Util *_util;

@implementation Util

+ (id)sharedInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _util = [[Util alloc]init];
    });
    return _util;
}

- (void) setHtml: (UILabel*)label  html:(NSString*) html
{
    NSError *err = nil;
    label.attributedText =
    [[NSAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}


- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%i", (int)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)openBrownserWithLink:(NSString *)link{
    if (link && link.length > 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link]];
    }
}
- (void)showHub:(BOOL)isShow{
    if (isShow) {
        [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
    }else{
        [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
    }
}

- (NSString *)getAppVerison{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
- (UIColor*)transformedColor:(NSString*)strColor {
    NSArray *arrColor = [strColor componentsSeparatedByString:@","];
    if (arrColor == nil || arrColor.count != 3) {
        return [UIColor whiteColor];
    }
    CGFloat red = [[arrColor objectAtIndex:0] floatValue] / 255.0;
    CGFloat green = [[arrColor objectAtIndex:1] floatValue] / 255.0;
    CGFloat blue = [[arrColor objectAtIndex:2] floatValue] / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //    [arrColor getObjects:0];
}


-(NSString *) timeLeftSinceDate:(NSDate *)dateT
{
    NSString *timeLeft = @"";
    
    NSDate *today10am =[NSDate date];
    
    NSTimeInterval  seconds = [today10am timeIntervalSinceDate:dateT];
    
    NSInteger years = (int) (floor(seconds / (3600 * 24 * 365)));
    if(years) seconds -= years * 3600 *365 * 24;
    
    NSInteger months = (int) (floor(seconds / (3600 * 24 * 30)));
    if(months) seconds -= months * 3600 *30 * 24;
    
    NSInteger weeks = (int) (floor(seconds / (3600 * 24 * 7)));
    if(weeks) seconds -= weeks * 3600 *7 * 24;
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(years > 0) {
        NSString *str = [NSString stringWithFormat:@"%ldy", (long)years];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(years > 1)
            timeLeft = [timeLeft stringByAppendingString:@"rs "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(months) {
        NSString *str = [NSString stringWithFormat:@"%ldm", (long)months];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(months > 1)
            timeLeft = [timeLeft stringByAppendingString:@"s "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(weeks) {
        NSString *str = [NSString stringWithFormat:@"%ldw", (long)weeks];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(weeks > 1)
            timeLeft = [timeLeft stringByAppendingString:@"ks "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(days) {
        NSString *str = [NSString stringWithFormat:@"%ldd", (long)days];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(days > 1)
            timeLeft = [timeLeft stringByAppendingString:@"s "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(hours) {
        NSString *str = [NSString stringWithFormat:@"%ldh", (long)hours];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(hours > 1)
            timeLeft = [timeLeft stringByAppendingString:@"rs "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(minutes) {
        NSString *str = [NSString stringWithFormat:@"%ldmin", (long)minutes];
        timeLeft = [timeLeft stringByAppendingString:str];
        
        if(minutes > 1)
            timeLeft = [timeLeft stringByAppendingString:@"s "];
        else
            timeLeft = [timeLeft stringByAppendingString:@" "];
    }
    if(seconds) {
        NSString *str = [NSString stringWithFormat:@"%lds ", (long)seconds];
        timeLeft = [timeLeft stringByAppendingString:str];
    }   
    timeLeft = [timeLeft stringByAppendingString:@"ago"];
    return timeLeft;
}
@end
