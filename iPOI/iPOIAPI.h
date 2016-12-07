//
//  iPOIAPI.h
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface iPOIAPI : NSObject

+ (instancetype) sharedInstance;

- (NSInteger)  poiCount;
- (NSString *) poiNameAtIndex:(NSInteger)index;
- (NSString *) poiIconURLStringAtIndex:(NSInteger)index;
- (NSString *) poiAddressAtIndex:(NSInteger)index;
- (NSNumber *) poiRatingAtIndex:(NSInteger)index;

- (NSInteger)  poiPhotoCountAtIndex:(NSInteger)index;
- (NSString *) poiPhotoRefPOIAtIndex:(NSInteger)index andPhotoAtIndex:(NSInteger)photoIndex;

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure;
                           
- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

@end
