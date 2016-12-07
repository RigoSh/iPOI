//
//  iPOIHTTPImageManager.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIHTTPImageManager.h"

static NSString *const baseURLString = @"https://maps.googleapis.com/maps/api/place/";

@implementation iPOIHTTPImageManager{
    NSString *_apiKey;
}

+ (instancetype) sharedInstanceWithAPIKey:(NSString *)apiKey
{
    static iPOIHTTPImageManager *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]
                                    andWithAPIKey:apiKey];
    });
    
    return _instance;
}

- (instancetype) initWithBaseURL: (NSURL *)baseURL andWithAPIKey:(NSString *)apiKey
{
    self = [super initWithBaseURL:baseURL];
    
    if(self)
    {
        _apiKey = apiKey;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFImageResponseSerializer serializer];
    }
    
    return self;
}

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"key"] = _apiKey;
    params[@"photoreference"] = photoRef;
    params[@"maxwidth"] = @(500);
    
    [self GET:@"photo"
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          success(responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(error);
      }];
}

@end
