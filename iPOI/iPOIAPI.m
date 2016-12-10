//
//  iPOIAPI.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIAPI.h"
#import "iPOIObject.h"
#import "iPOIDetailObject.h"
#import "iPOIHTTPDataManager.h"
#import "iPOIHTTPImageManager.h"
#import "iPOIHTTPDetailDataManager.h"
#import <UIImageView+AFNetworking.h>
#import <CoreData/CoreData.h>

static NSInteger const maxPOICount       = 20;
static NSInteger const maxPOIPhotoCount  = 10;
static NSString *const kResponseStatus   = @"status";
static NSString *const kPlaceHolderImage = @"PlaceHolderImage.png";

@implementation iPOIAPI{
    iPOIObject *_poi;
    iPOIDetailObject *_poiDetail;
    iPOIHTTPDataManager *_poiDataManager;
    iPOIHTTPImageManager *_poiImageManager;
    iPOIHTTPDetailDataManager *_poiDetailDataManager;
    NSString *_GoogleAPIKey;
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
        _GoogleAPIKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleAPIKey"];
        _poiDataManager = [iPOIHTTPDataManager sharedInstanceWithAPIKey:_GoogleAPIKey];
        _poiImageManager = [iPOIHTTPImageManager sharedInstanceWithAPIKey:_GoogleAPIKey];
        _poiDetailDataManager = [iPOIHTTPDetailDataManager sharedInstanceWithAPIKey:_GoogleAPIKey];
    }
    
    return self;
}

- (CLLocationCoordinate2D) poiCoordinate2DAtIndex:(NSInteger)index
{
    return [_poi poiCoordinate2DAtIndex:index];
}

#pragma mark - POI object

- (NSInteger) poiCount
{
    if (!_poi)
    {
        return 0;
    }
    else
    {
        if ([_poi poiCount] > maxPOICount)
        {
            return maxPOICount;
        }
        else
        {
            return [_poi poiCount];
        }
    }
}

- (NSString *) poiPlaceIDAtIndex:(NSInteger)index
{
    return [_poi poiPlaceIDAtIndex:index];
}

- (NSString *) poiNameAtIndex:(NSInteger)index
{
    return [_poi poiNameAtIndex:index];
}

- (NSString *) poiIconURLStringAtIndex:(NSInteger)index
{
    return [_poi poiIconURLStringAtIndex:index];
}

#pragma mark - POI Detailed object

- (NSInteger) poiDetailPhotoCount
{
    if (!_poiDetail)
    {
        return 0;
    }
    else
    {
        if ([_poiDetail poiPhotoCount] > maxPOIPhotoCount)
        {
            return maxPOIPhotoCount;
        }
        else
        {
            return [_poiDetail poiPhotoCount];
        }
    }
    
    return [_poiDetail poiPhotoCount];
}

- (NSString *) poiDetailName
{
    return [_poiDetail poiName];
}

- (NSString *) poiDetailAddress
{
    return [_poiDetail poiAddress];
}

- (NSString *) poiDetailPhone
{
    return [_poiDetail poiPhone];
}

- (NSNumber *) poiDetailRating
{
    return [_poiDetail poiRating];
}

- (NSString *) poiDetailPhotoRefAtIndex:(NSInteger)photoIndex
{
    return [_poiDetail poiPhotoRefAtIndex:photoIndex];
}

- (BOOL) poiDetailOpenNow
{
    return [_poiDetail poiOpenNow];
}

#pragma mark - common functions

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure
{
    [_poiDataManager getPOIAtLocation:location
                              success:^(id responseObject) {
                                  if([responseObject[kResponseStatus] isEqualToString:@"OK"] ||
                                     [responseObject[kResponseStatus] isEqualToString:@"ZERO_RESULTS"])
                                  {
                                      _poi = [[iPOIObject alloc] initWithResponse:responseObject];
                                  }
                                  else
                                  {
                                      _poi = nil;
                                  }
                                  
                                  success();
                              }
                              failure:^(NSError *error) {
                                  _poi = nil;
                                  failure(error);
                              }];
}

- (void) getPOIDetailWithPlaceID:(NSString *)placeID
                         success:(void(^)())success
                         failure:(void(^)(NSError *error))failure
{
    [_poiDetailDataManager getPOIDetailWithPlaceID:placeID
                                           success:^(id responseObject){
                                               if([responseObject[kResponseStatus] isEqualToString:@"OK"] ||
                                                  [responseObject[kResponseStatus] isEqualToString:@"ZERO_RESULTS"])
                                               {
                                                   _poiDetail = [[iPOIDetailObject alloc] initWithResponse:responseObject];
                                               }
                                               else
                                               {
                                                   _poiDetail = nil;
                                               }
                                               
                                               success();
                                           }
                                           failure:^(NSError *error) {
                                               _poiDetail = nil;
                                               failure(error);
                                           }];
}

- (void) getPOIIconForCell:(UITableViewCell *)cell
                AtIndexRow:(NSInteger)indexRow
                   success:(void(^)(UIImage *image))success
                   failure:(void(^)(NSError *error))failure
{
    NSURL *iconURL = [NSURL URLWithString:[self poiIconURLStringAtIndex:indexRow]];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconURL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:60
                             ];
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:kPlaceHolderImage]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       success(image);
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       failure(error);
                                   }];
}

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;
{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:photoRef];
    
    if(imageData)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image)
        {
            success(image);
        }
        else
        {
            failure(nil);
        }
    }
    else
    {
        [_poiImageManager getPOIPhotoWithRef:photoRef
                                     success:^(id responseObject) {
                                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(responseObject) forKey:photoRef];
                                         success(responseObject);
                                     }
                                     failure:^(NSError *error) {
                                         failure(error);
                                     }];
    }
}

@end
