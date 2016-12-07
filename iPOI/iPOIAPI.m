//
//  iPOIAPI.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIAPI.h"
#import "iPOIObject.h"
#import "iPOIHTTPDataManager.h"
#import "iPOIHTTPImageManager.h"

static NSInteger const maxPOICount = 20;
static NSString *const kGoogleAPIKey = @"AIzaSyCM1fGbzyN878C0102xOSD_Cw_sfMPU0Pk";

@implementation iPOIAPI{
    iPOIObject *_poi;
    iPOIHTTPDataManager *_poiDataManager;
    iPOIHTTPImageManager *_poiImageManager;
}

+ (instancetype) sharedInstance
{
    static iPOIAPI *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        _poiDataManager = [iPOIHTTPDataManager sharedInstanceWithAPIKey:kGoogleAPIKey];
        _poiImageManager = [iPOIHTTPImageManager sharedInstanceWithAPIKey:kGoogleAPIKey];
    }
    
    return self;
}

- (NSInteger) poiCount
{
    if (!_poi)
    {
        return 0;
    }
    else
    {
        if ([_poi count] > maxPOICount)
        {
            return maxPOICount;
        }
        else
        {
            return [_poi count];
        }
    }
}

- (NSString *) poiNameAtIndex:(NSInteger)index
{
    return [_poi poiNameAtIndex:index];
}

- (NSString *) poiIconURLStringAtIndex:(NSInteger)index
{
    return [_poi poiIconURLStringAtIndex:index];
}

- (NSString *) poiAddressAtIndex:(NSInteger)index
{
    return [_poi poiAddressAtIndex:index];
}

- (NSNumber *) poiRatingAtIndex:(NSInteger)index
{
    return [_poi poiRatingAtIndex:index];
}

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure
{
    [_poiDataManager getPOIAtLocation:location
                              success:^(id responseObject) {
                                  _poi = [[iPOIObject alloc] initWithResponse:responseObject];
                                  success();
                              }
                              failure:^(NSError *error) {
                                  _poi = nil;
                                  failure(error);
                              }];
}

- (NSInteger) poiPhotoCountAtIndex:(NSInteger)index
{
    if (!_poi)
    {
        return 0;
    }
    else
    {
        if ([_poi count] > index)
        {
            return [_poi photoCountPOIAtIndex:index];
        }
        else
        {
            return 0;
        }
    }
}

- (NSString *) poiPhotoRefPOIAtIndex:(NSInteger)index andPhotoAtIndex:(NSInteger)photoIndex
{
    return [_poi poiPhotoRefPOIAtIndex:index andPhotoAtIndex:photoIndex];
}

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;
{
    [_poiImageManager getPOIPhotoWithRef:photoRef
                                 success:^(id responseObject) {
                                     success(responseObject);
                                 }
                                 failure:^(NSError *error) {
                                     failure(error);
                                 }];
}

@end
