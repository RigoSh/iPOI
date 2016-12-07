//
//  iPOIHTTPImageManager.h
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface iPOIHTTPImageManager : AFHTTPSessionManager

+ (instancetype) sharedInstanceWithAPIKey:(NSString *)apiKey;

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

@end
