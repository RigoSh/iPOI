//
//  iPOIHTTPDataManager.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIHTTPDataManager.h"

static NSString *const baseURLString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/";

@implementation iPOIHTTPDataManager{
    NSString *_apiKey;
}

+ (instancetype) sharedInstanceWithAPIKey:(NSString *)apiKey
{
    static iPOIHTTPDataManager *_instance = nil;
    
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
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"key"] = _apiKey;
    params[@"location"] = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    params[@"types"] = @"bar|cafe|hotel";
    params[@"radius"] = @(500);
    params[@"language"] = @"ru";
    
    [self GET:@"json"
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          success(responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(error);
      }];
}

- (void)getPOIForPagetoken:(NSString *)pagetoken
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"key"] = _apiKey;
    params[@"pagetoken"] = pagetoken;
    
    [self GET:@"json"
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          success(responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(error);
      }];
}

@end
