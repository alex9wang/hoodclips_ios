//
//  AppDelegate.m
//  hoodclips
//
//  Created by sworld on 05/27/2016
//  Copyright (c) 2016 sworld. All rights reserved.
//

#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "WebService.h"
#import "InAppPurchaseController.h"
#import "Analytics.h"
#import "ALSdk.h"
#import <MMAdSDK/MMAdSDK.h>


@import Batch;

@implementation AppDelegate
@synthesize navController,storyBoard;

//@synthesize loginView,allVideoView,videoView;
+(id) shardAppDeleget
{
    return (id)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Analytics init];
    // Override point for customization after application launch.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    
    // Clear application badge when app launches
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil) {
        [self application:application didReceiveRemoteNotification:userInfo];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
#else
        // use registerForRemoteNotificationTypes:
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
#endif         
    }
    
    [BatchPush setupPush];
    [Batch startWithAPIKey:@"56C5F86C1472ABB72C46AC07477F60"];
    // Register for push notifications
    [BatchPush registerForRemoteNotifications];
    
    [ALSdk initializeSdk];
    // initialize MMSDK
    //[[MMSDK sharedInstance] initializeWithSettings:nil withUserSettings:nil];
    
    //[[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successInAppPurchase:)
                                                 name:IAPHelperProductPurchasedNotification
                                               object:nil];
    
    _videoShowCount = 0;
    
    return YES;
}


- (void)successInAppPurchase:(NSNotification*)ntf {
    NSString* productId = [ntf.userInfo objectForKey:IAPHelperProductPurchasedNotification];
    if (productId.length > 0) {
        if ([productId isEqualToString:kIAPItemProductId199]) {
            APPDELEGATE.isPurchased = 1;
            [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isPurchased"];
            return;
        }        
    }
}

-(void)showAllVideos
{
    UINavigationController *secondNav = [storyBoard instantiateViewControllerWithIdentifier:@"VideoRootNavViewController"];
    self.window.rootViewController = secondNav;
    self.navController = secondNav;
    //[navController pushViewController: allVideoView animated:YES];
}

-(void)goBackTo
{
    [navController popViewControllerAnimated: YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString *)getUUID {
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    return Identifier;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    NSString *devToken = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    [param setObject:devToken forKey:POST_PARAM_WEBAPI_TOKEN];
    [WEBSERVICE postRequest:SAVE_TOKEN_URL param:param success:^(id responseObject) {
        [UTIL showHub:NO];
    } failure:^(NSError *error) {
        [UTIL showHub:NO];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}



@end
