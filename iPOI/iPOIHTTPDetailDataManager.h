//
//  iPOIHTTPDetailDataManager.h
//  iPOI
//
//  Created by Rigo on 08/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface iPOIHTTPDetailDataManager : AFHTTPSessionManager

+ (instancetype) sharedInstanceWithAPIKey:(NSString *)apiKey;

- (void) getPOIDetailWithPlaceID:(NSString *)placeID
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;

@end
