//
//  WebService.h
//  Media
//
//  Created by BaoAnh on 11/1/14.
//  Copyright (c) 2014 BaoAnh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "Util.h"

#define RESPOND_STATUS_SUCCESS  200
#define STATUS_OK               @"ok"
#define WEBSERVICE      [WebService sharedInstant]

@interface WebService : NSObject

+ (id)sharedInstant;

//- (void)loadRequest:(NSString *)apiName param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)getRequest:(NSString *)apiName param:(NSString *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)loadRequest:(NSString *)apiName param:(NSString *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)postRequest:(NSString *)subUrl param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)postImageRequest:(NSString *)subUrl fieldName:(NSString*)fieldName imageData:(NSData*)imageData success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)checkNetworkStatus:(UIViewController*)viewController;
    
@end
