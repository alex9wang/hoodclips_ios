//
//  ShareThis.m
//  NguoiBiAn
//
//  Created by BaoAnh on 5/3/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ShareThis.h"
#import <UIKit/UIKit.h>

static ShareThis *_shareThis;

@implementation ShareThis

+ (id)sharedInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareThis = [[ShareThis alloc]init];
    });
    return _shareThis;
}

//- (void)shareFaceWithItem:(id)item{
//    if (!item) {
//        return;
//    }
//    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
//    if ([item isKindOfClass:[Video class]]) {
//        Video *video = (Video *)item;
//        if (video.cover && video.cover.length>0) {
//            params.picture = [NSURL URLWithString:video.cover];
//        }
//        params.link = [NSURL URLWithString:APP_LINK];
//        params.caption = @"";
//        params.name = video.name;
//        params.description = APP_STORE_NAME;
//    }
//    if ([item isKindOfClass:[NSString class]]) {
//        params.link = [NSURL URLWithString:APP_LINK];
//        params.caption = @"";
//        params.name = APP_STORE_NAME;
//        params.description = APP_STORE_DESCRIPTION;
//    }
//    if (!params.link) {
//        return;
//    }
//    
//    // If the Facebook app is installed and we can present the share dialog
//    if ([FBDialogs canPresentShareDialogWithParams:params]) {
//        // Present share dialog
//        [FBDialogs presentShareDialogWithLink:params.link
//                                         name:params.name
//                                      caption:params.caption
//                                  description:params.description
//                                      picture:params.picture
//                                  clientState:nil
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"Error publishing story");
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                          }
//                                      }];
//    } else {
//        // Present the feed dialog
//        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                      params.name, @"name",
//                                      @"", @"caption",
//                                      params.description, @"description",
//                                      params.link, @"link",
//                                      params.picture, @"picture",
//                                      nil];
//        
//        // Show the feed dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession]
//                                               parameters:param
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          NSLog(@"Error publishing story: %@", error.description);
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                          } else {
//                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                              
//                                                              if (![urlParams valueForKey:@"post_id"]) {
//                                                                  // User canceled.
//                                                                  NSLog(@"User cancelled.");
//                                                                  
//                                                              } else {
//                                                                  // User clicked the Share button
//                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                                  NSLog(@"result %@", result);
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//    }
//}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)shareActivityControllerWithContent:(NSString *)content viewController:(UIViewController *)viewController{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[content]
                                      applicationActivities:nil];
    
//    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
//                                         UIActivityTypeMessage,
//                                         UIActivityTypeMail,
//                                         UIActivityTypePrint,
//                                         UIActivityTypeCopyToPasteboard,
//                                         UIActivityTypeAssignToContact,
//                                         UIActivityTypeSaveToCameraRoll,
//                                         UIActivityTypeAddToReadingList,
//                                         UIActivityTypePostToFlickr,
//                                         UIActivityTypePostToVimeo,
//                                         UIActivityTypePostToTencentWeibo,
//                                         UIActivityTypeAirDrop];
    
    if (viewController) {
        
        if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            CGRect rect = viewController.view.bounds;
            rect.size.height = rect.size.height/2 - 100;
            activityViewController.popoverPresentationController.sourceView = viewController.view;
            activityViewController.popoverPresentationController.sourceRect = rect;
        }
        
        
        [viewController presentViewController:activityViewController animated:YES completion:nil];
    }
}

@end
