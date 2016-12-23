//
//  POIItem.h
//  iPOI
//
//  Created by Rigo on 23/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>

@interface POIItem : NSObject<GMUClusterItem>

@property (nonatomic, readonly) CLLocationCoordinate2D position;
@property (nonatomic, readonly) NSString *name;

- (instancetype) initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name;

@end
