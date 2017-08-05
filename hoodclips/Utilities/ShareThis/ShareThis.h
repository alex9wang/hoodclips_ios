//
//  ShareThis.h
//  NguoiBiAn
//
//  Created by BaoAnh on 5/3/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHARE_THIS  [ShareThis sharedInstant]

@class ShareThis;

@interface ShareThis : NSObject

@property (nonatomic, retain) id parentVC;

+ (id)sharedInstant;
//- (void)shareFaceWithItem:(id)item;
- (void)shareActivityControllerWithContent:(NSString *)content viewController:(UIViewController*)viewController;

@end
