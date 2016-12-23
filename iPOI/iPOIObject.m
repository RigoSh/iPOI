//
//  iPOIObject.m
//  iPOI
//
//  Created by Rigo on 06/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIObject.h"

static NSString *const kSearchResults   = @"results";
static NSString *const kSearchPagetoken = @"next_page_token";
static NSString *const kPOIName         = @"name";
static NSString *const kPOIPlaceID      = @"place_id";
static NSString *const kPOIIconURL      = @"icon";
static NSString *const kPOIPhotos       = @"photos";
static NSString *const kPOIPhotoRef     = @"photo_reference";
static NSString *const kPOIAddress      = @"vicinity";
static NSString *const kPOIRating       = @"rating";
static NSString *const kPOIGeometry     = @"geometry";
static NSString *const kPOILocation     = @"location";

@implementation iPOIObject{
    NSMutableDictionary *_poiResponse;
}

- (instancetype) initWithResponse:(NSDictionary *)response
{
    self = [super init];
    
    if (self)
    {
        _poiResponse = [NSMutableDictionary dictionaryWithDictionary:response];
    }
    
    return self;
}

- (NSInteger) poiCount
{
    if(_poiResponse)
    {
        NSArray *poiResults = _poiResponse[kSearchResults];
        
        return [poiResults count];
    }
    else
    {
        return 0;
    }
}

- (NSString *)poiPagetoken
{
    if(_poiResponse)
    {
        NSString *pagetoken = _poiResponse[kSearchPagetoken];
        
        return pagetoken;
    }
    else
    {
        return nil;
    }
}

- (NSString *) poiPlaceIDAtIndex:(NSInteger)index;
{
    if(_poiResponse)
    {
        if(index >= [self poiCount])
        {
            return nil;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSString *placeID = poi[kPOIPlaceID];
        
        return placeID;
    }
    else
    {
        return nil;
    }
}

- (void)poiUnionWithResponse:(NSDictionary *)responseObject
{
    if(_poiResponse)
    {
        _poiResponse[kSearchPagetoken] = responseObject[kSearchPagetoken];
        
        NSMutableArray *results = [NSMutableArray arrayWithArray:responseObject[kSearchResults]];
        [results addObjectsFromArray:_poiResponse[kSearchResults]];
        
        _poiResponse[kSearchResults] = results;
    }
    else
    {
        return;
    }
}

- (CLLocationCoordinate2D) poiCoordinate2DAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSDictionary *poiLocation = [[poi valueForKey:kPOIGeometry] valueForKey:kPOILocation];
        NSNumber *latitude = poiLocation[@"lat"];
        NSNumber *longitude = poiLocation[@"lng"];
        
        CLLocationCoordinate2D poiCoordinate2D = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        
        return poiCoordinate2D;
    }
    else
    {
        return CLLocationCoordinate2DMake(0, 0);
    }
}

- (NSString *) poiNameAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self poiCount])
        {
            return nil;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSString *name = poi[kPOIName];
        
        return name;
    }
    else
    {
        return nil;
    }
}

- (NSString *) poiIconURLStringAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self poiCount])
        {
            return nil;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSString *iconURLString = poi[kPOIIconURL];

        return iconURLString;
    }
    else
    {
        return nil;
    }
}

@end
