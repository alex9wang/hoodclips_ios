//
//  WebService.m
//  Media
//
//  Created by BaoAnh on 11/1/14.
//  Copyright (c) 2014 BaoAnh. All rights reserved.
//

#import "WebService.h"
#import "Util.h"

#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"

@implementation WebService

static WebService *_webService;

+ (id)sharedInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webService = [[WebService alloc]init];
    });
    return _webService;
}
- (NSString *)subUrlFromApiName:(NSString *)apiName param:(NSDictionary *)param{
    NSString *subUrl = apiName;
    if (param) {
        NSString *keyValue;
        NSString *moreUrl = @"&";
        for (NSString *key in param.allKeys) {
            if (key.length > 0) {
                NSString *value = [param objectForKey:key];
                if (moreUrl.length == 1) {
                    keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                }else{
                    keyValue = [NSString stringWithFormat:@"&%@=%@", key, value];
                }
                moreUrl = [moreUrl stringByAppendingString:keyValue];
            }
        }
        subUrl = [subUrl stringByAppendingString:moreUrl];
    }
    return subUrl;
}
- (void)loadRequest:(NSString *)apiName param:(NSString *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *subUrl = [NSString stringWithFormat:@"%@/%@", apiName, param];
    NSString *urlString =[BASE_URL stringByAppendingString:subUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON of api %@: %@",apiName, responseObject);
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error of api %@: %@",apiName, error);
        failure(error);
    }];
}

- (void)getRequest:(NSString *)apiName param:(NSString *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *subUrl = [NSString stringWithFormat:@"%@/%@/1", apiName, param];
    NSString *urlString = [BASE_URL stringByAppendingString:subUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON of api %@: %@",apiName, responseObject);
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error of api %@: %@",apiName, error);
        failure(error);
    }];
}
//- (void)postRequest:(NSString *)apiName param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
//    NSString *subUrl = [self subUrlFromApiName:apiName param:nil];
//    NSString *urlString = [BASE_URL stringByAppendingString:subUrl];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON of api %@: %@",apiName, responseObject);
//        success(operation.responseString);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error of api %@: %@",apiName, error);
//        failure(error);
//    }];
//}

- (void)postRequest:(NSString *)subUrl param:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
//    NSString *subUrl = [self subUrlFromApiName:apiName param:nil];
    NSString *urlString = [BASE_URL stringByAppendingString:subUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:100];
    
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *jsonStr = [param JSONString];
    [request setHTTPBody: [jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON of api %@: %@",subUrl, responseObject);
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error of api %@: %@",subUrl, error);
        failure(error);
    }];
    [op start];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON of api %@: %@",apiName, responseObject);
//        success(operation.responseString);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

- (void)postImageRequest:(NSString *)subUrl fieldName:(NSString*)fieldName imageData:(NSData*)imageData success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
//    NSString *subUrl = [self subUrlFromApiName:apiName param:nil];
    NSString *urlString = [BASE_URL stringByAppendingString:subUrl];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    id boundary = BOUNDARY;
    NSString *FileParamConstant = fieldName;
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"imagen.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)body.length];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON of api %@: %@",subUrl, responseObject);
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error of api %@: %@",subUrl, error);
        failure(error);
    }];
    [op start];
}

- (void)checkNetworkStatus:(UIViewController*)viewController {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // -- Reachable -- //
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
                // -- Not reachable -- //
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification"
//                                                                message:@"Please confirm Wi-Fi state."
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
                UIViewController *videoView = [viewController.storyboard instantiateViewControllerWithIdentifier:@"ConnectionErrorViewController"];
                [viewController.navigationController pushViewController:videoView animated:YES];
            }
            break;
        }
        
    }];
}

@end
