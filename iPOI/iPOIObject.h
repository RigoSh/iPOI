//
//  iPOIObject.h
//  iPOI
//
//  Created by Rigo on 06/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface iPOIObject : NSObject

- (instancetype) initWithResponse:(NSDictionary *)response;

- (CLLocationCoordinate2D) poiCoordinate2DAtIndex:(NSInteger)index;

- (NSInteger)  poiCount;
- (NSString *) poiNameAtIndex:(NSInteger)index;
- (NSString *) poiPlaceIDAtIndex:(NSInteger)index;
- (NSString *) poiIconURLStringAtIndex:(NSInteger)index;

@end
