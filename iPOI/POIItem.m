//
//  POIItem.m
//  iPOI
//
//  Created by Rigo on 23/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "POIItem.h"

@implementation POIItem

- (instancetype) initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name
{
    self = [super init];
    
    if(self)
    {
        _position = position;
        _name = name;
    }
    
    return self;
}

@end
