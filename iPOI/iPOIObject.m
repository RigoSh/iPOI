//
//  iPOIObject.m
//  iPOI
//
//  Created by Rigo on 06/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIObject.h"

static NSString *const kSearchResults   = @"results";
static NSString *const kPOIName         = @"name";
static NSString *const kPOIIconURL      = @"icon";
static NSString *const kPOIPhotos       = @"photos";
static NSString *const kPOIPhotoRef     = @"photo_reference";
static NSString *const kPOIAddress      = @"vicinity";
static NSString *const kPOIRating       = @"rating";

@implementation iPOIObject{
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

- (NSInteger) count
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


- (NSInteger) photoCountPOIAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self count])
        {
            return 0;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
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

- (NSString *) poiNameAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self count])
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

- (NSString *) poiPhotoRefPOIAtIndex:(NSInteger)index andPhotoAtIndex:(NSInteger)photoIndex
{
    if(_poiResponse)
    {
        if(index >= [self count])
        {
            return nil;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSArray *photos = poi[kPOIPhotos];
        
        if (photos)
        {
            if(photoIndex >= [photos count])
            {
                return nil;
            }
            
            NSDictionary *photo = photos[photoIndex];
            NSString *photoRef = photo[kPOIPhotoRef];
            
            return photoRef;
        }
        else
        {
            return nil;
        }
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
        if(index >= [self count])
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

- (NSString *) poiAddressAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self count])
        {
            return nil;
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSString *address = poi[kPOIAddress];
        
        return address;
    }
    else
    {
        return nil;
    }
}

- (NSNumber *) poiRatingAtIndex:(NSInteger)index
{
    if(_poiResponse)
    {
        if(index >= [self count])
        {
            return @(0);
        }
        
        NSArray *poiArray = _poiResponse[kSearchResults];
        NSDictionary *poi = poiArray[index];
        
        NSNumber *rating = poi[kPOIRating];
        
        if (rating == nil)
        {
            return @(0);
        }
        
        return rating;
    }
    else
    {
        return @(0);
    }
}

@end
