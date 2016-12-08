//
//  iPOIDetailObject.m
//  iPOI
//
//  Created by Rigo on 08/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIDetailObject.h"

static NSString *const kPOIResult       = @"result";
static NSString *const kPOIName         = @"name";
static NSString *const kPOIPhotos       = @"photos";
static NSString *const kPOIPhotoRef     = @"photo_reference";
static NSString *const kPOIAddress      = @"formatted_address";
static NSString *const kPOIPhone        = @"international_phone_number";
static NSString *const kPOIRating       = @"rating";
static NSString *const kPOIGeometry     = @"geometry";
static NSString *const kPOILocation     = @"location";
static NSString *const kPOIOpeningHours = @"opening_hours";
static NSString *const kPOIOpenNow      = @"open_now";

@implementation iPOIDetailObject{
    NSDictionary *_poiResponse;
}

- (instancetype) initWithResponse:(NSDictionary *)response
{
    self = [super init];
    
    if (self)
    {
        _poiResponse = response;
    }
    
    return self;
}

- (NSInteger) poiPhotoCount
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSArray *photos = poi[kPOIPhotos];
        
        if (photos)
        {
            return [photos count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

- (NSString *) poiName
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSString *name = poi[kPOIName];
        
        return name;
    }
    else
    {
        return nil;
    }
}

- (NSString *) poiAddress
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSString *address = poi[kPOIAddress];
        
        return address;
    }
    else
    {
        return nil;
    }
}

- (NSString *) poiPhone
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSString *phone = poi[kPOIPhone];
        
        return phone;
    }
    else
    {
        return nil;
    }
}

- (NSNumber *) poiRating
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSNumber *rating = poi[kPOIRating];
        
        if (rating == nil)
        {
            return @(0);
        }
        
        return rating;
        
        return rating;
    }
    else
    {
        return @(0);
    }
}

- (NSString *) poiPhotoRefAtIndex:(NSInteger)photoIndex
{
    if(_poiResponse)
    {
        if(photoIndex >= [self poiPhotoCount])
        {
            return nil;
        }
        
        NSDictionary *poi = _poiResponse[kPOIResult];
        NSArray *photos = poi[kPOIPhotos];
        
        NSDictionary *photo = photos[photoIndex];
        NSString *photoRef = photo[kPOIPhotoRef];
        
        return photoRef;
    }
    else
    {
        return nil;
    }
}

- (BOOL) poiOpenNow
{
    if(_poiResponse)
    {
        NSDictionary *poi = _poiResponse[kPOIResult];
        BOOL opennow = [[poi objectForKey:kPOIOpeningHours] objectForKey:kPOIOpenNow];
        
        return opennow;
    }
    else
    {
        return NO;
    }
}

@end
