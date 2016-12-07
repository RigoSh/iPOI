//
//  iPOIObject.h
//  iPOI
//
//  Created by Rigo on 06/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPOIObject : NSObject

- (instancetype) initWithResponse:(NSDictionary *)response;

- (NSInteger)  count;
- (NSString *) poiNameAtIndex:(NSInteger)index;
- (NSString *) poiAddressAtIndex:(NSInteger)index;
- (NSNumber *) poiRatingAtIndex:(NSInteger)index;
- (NSString *) poiIconURLStringAtIndex:(NSInteger)index;

- (NSInteger)  photoCountPOIAtIndex:(NSInteger)index;
- (NSString *) poiPhotoRefPOIAtIndex:(NSInteger)index andPhotoAtIndex:(NSInteger)photoIndex;

@end
