//
//  iPOIDetailObject.h
//  iPOI
//
//  Created by Rigo on 08/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface iPOIDetailObject : NSObject

- (instancetype) initWithResponse:(NSDictionary *)response;

- (NSInteger)  poiPhotoCount;
- (NSString *) poiName;
- (NSString *) poiAddress;
- (NSString *) poiPhone;
- (NSNumber *) poiRating;
- (NSString *) poiPhotoRefAtIndex:(NSInteger)photoIndex;
- (BOOL)       poiOpenNow;

@end
