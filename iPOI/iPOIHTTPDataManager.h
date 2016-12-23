//
//  iPOIHTTPDataManager.h
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@interface iPOIHTTPDataManager : AFHTTPSessionManager

+ (instancetype) sharedInstanceWithAPIKey:(NSString *)apiKey;

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

- (void)getPOIForPagetoken:(NSString *)pagetoken
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;

@end
