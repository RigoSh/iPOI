//
//  iPOIAPI.h
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface iPOIAPI : NSObject

+ (instancetype) sharedInstance;
- (void)poiClear;

- (CLLocationCoordinate2D) poiCoordinate2DAtIndex:(NSInteger)index;

- (NSInteger)  poiCount;
- (NSString *) poiPlaceIDAtIndex:(NSInteger)index;
- (NSString *) poiNameAtIndex:(NSInteger)index;
- (NSString *) poiIconURLStringAtIndex:(NSInteger)index;

- (NSInteger)  poiDetailPhotoCount;
- (NSString *) poiDetailName;
- (NSString *) poiDetailAddress;
- (NSString *) poiDetailPhone;
- (NSNumber *) poiDetailRating;
- (NSString *) poiDetailPhotoRefAtIndex:(NSInteger)photoIndex;
- (BOOL)       poiDetailOpenNow;

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure;

- (void)addPOIAndFinishWithSuccess:(void(^)(BOOL haveNewPOI))success
                           failure:(void(^)(NSError *error))failure;

- (void) getPOIIconForCell:(UITableViewCell *)cell
                AtIndexRow:(NSInteger)indexRow
                   success:(void(^)(UIImage *image))success
                   failure:(void(^)(NSError *error))failure;

- (void) getPOIDetailWithPlaceID:(NSString *)placeID
                         success:(void(^)())success
                         failure:(void(^)(NSError *error))failure;

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

@end
