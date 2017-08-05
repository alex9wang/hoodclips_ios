//
//  AppDelegate.h
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"
#import "ConnectionErrorViewController.h"

#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) UIStoryboard              *storyBoard;
@property (strong, nonatomic) UINavigationController    *navController;

+ (id) shardAppDeleget;
-(void)showAllVideos;
-(void)goBackTo;
-(NSString *)getUUID;
@property (nonatomic) NSString* uuid;
@property (nonatomic, assign) int isPurchased;
@property (nonatomic, assign) int videoShowCount;


@end
