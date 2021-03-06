//
//  iPOIAPI.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIAPI.h"
#import "AppDelegate.h"
#import "iPOIObject.h"
#import "iPOIDetailObject.h"
#import "iPOIHTTPDataManager.h"
#import "iPOIHTTPImageManager.h"
#import "iPOIHTTPDetailDataManager.h"
#import <UIImageView+AFNetworking.h>
#import <CoreData/CoreData.h>

//static NSInteger const maxPOICount       = 20;
static NSInteger const maxPOIPhotoCount  = 10;
static NSString *const kResponseStatus   = @"status";
static NSString *const kPlaceHolderImage = @"PlaceHolderImage.png";

// CoreData keys
static NSString *const kImageDataAttr      = @"data";
static NSString *const kImageIDAttr        = @"imageID";
static NSString *const kImageLastUsedAttr  = @"lastUsedTimestamp";
static NSString *const kImageWithIDRequest = @"ImageWithID";
static NSString *const kImageEntity        = @"Image";

@implementation iPOIAPI{
    iPOIObject *_poi;
    iPOIDetailObject *_poiDetail;
    iPOIHTTPDataManager *_poiDataManager;
    iPOIHTTPImageManager *_poiImageManager;
    iPOIHTTPDetailDataManager *_poiDetailDataManager;
    NSString *_GoogleAPIKey;
}

+ (instancetype) sharedInstance
{
    static iPOIAPI *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        _GoogleAPIKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleAPIKey"];
        _poiDataManager = [iPOIHTTPDataManager sharedInstanceWithAPIKey:_GoogleAPIKey];
        _poiImageManager = [iPOIHTTPImageManager sharedInstanceWithAPIKey:_GoogleAPIKey];
        _poiDetailDataManager = [iPOIHTTPDetailDataManager sharedInstanceWithAPIKey:_GoogleAPIKey];
    }
    
    return self;
}

- (void)poiClear
{
    _poi = nil;
    _poiDetail = nil;
}

- (CLLocationCoordinate2D) poiCoordinate2DAtIndex:(NSInteger)index
{
    return [_poi poiCoordinate2DAtIndex:index];
}

#pragma mark - POI object

- (NSInteger) poiCount
{
    if (!_poi)
    {
        return 0;
    }
    else
    {
        return [_poi poiCount];
    }
}

- (NSString *) poiPlaceIDAtIndex:(NSInteger)index
{
    return [_poi poiPlaceIDAtIndex:index];
}

- (NSString *) poiNameAtIndex:(NSInteger)index
{
    return [_poi poiNameAtIndex:index];
}

- (NSString *) poiIconURLStringAtIndex:(NSInteger)index
{
    return [_poi poiIconURLStringAtIndex:index];
}

#pragma mark - POI Detailed object

- (NSInteger) poiDetailPhotoCount
{
    if (!_poiDetail)
    {
        return 0;
    }
    else
    {
        if ([_poiDetail poiPhotoCount] > maxPOIPhotoCount)
        {
            return maxPOIPhotoCount;
        }
        else
        {
            return [_poiDetail poiPhotoCount];
        }
    }
    
    return [_poiDetail poiPhotoCount];
}

- (NSString *) poiDetailName
{
    return [_poiDetail poiName];
}

- (NSString *) poiDetailAddress
{
    return [_poiDetail poiAddress];
}

- (NSString *) poiDetailPhone
{
    return [_poiDetail poiPhone];
}

- (NSNumber *) poiDetailRating
{
    return [_poiDetail poiRating];
}

- (NSString *) poiDetailPhotoRefAtIndex:(NSInteger)photoIndex
{
    return [_poiDetail poiPhotoRefAtIndex:photoIndex];
}

- (BOOL) poiDetailOpenNow
{
    return [_poiDetail poiOpenNow];
}

#pragma mark - common functions

- (void) getPOIAtLocation:(CLLocation *)location
                  success:(void(^)())success
                  failure:(void(^)(NSError *error))failure
{
    [_poiDataManager getPOIAtLocation:location
                              success:^(id responseObject) {
                                  if([responseObject[kResponseStatus] isEqualToString:@"OK"] ||
                                     [responseObject[kResponseStatus] isEqualToString:@"ZERO_RESULTS"])
                                  {
                                      _poi = [[iPOIObject alloc] initWithResponse:responseObject];
                                  }
                                  else
                                  {
                                      _poi = nil;
                                  }
                                  
                                  success();
                              }
                              failure:^(NSError *error) {
                                  _poi = nil;
                                  failure(error);
                              }];
}

- (void)addPOIAndFinishWithSuccess:(void(^)(BOOL haveNewPOI))success
                 failure:(void(^)(NSError *error))failure
{
    if(_poi == nil)
    {
        success(NO);
        return;
    }
    else if ([_poi poiPagetoken] == nil)
    {
        success(NO);
        return;
    }
    
    [_poiDataManager getPOIForPagetoken:[_poi poiPagetoken]
                              success:^(id responseObject) {
                                  if([responseObject[kResponseStatus] isEqualToString:@"OK"] ||
                                     [responseObject[kResponseStatus] isEqualToString:@"ZERO_RESULTS"])
                                  {
                                      [_poi poiUnionWithResponse:responseObject];
                                      success(YES);
                                  }
                                  
                                  success(NO);
                              }
                              failure:^(NSError *error) {
                                  _poi = nil;
                                  failure(error);
                              }];
}

- (void) getPOIDetailWithPlaceID:(NSString *)placeID
                         success:(void(^)())success
                         failure:(void(^)(NSError *error))failure
{
    [_poiDetailDataManager getPOIDetailWithPlaceID:placeID
                                           success:^(id responseObject){
                                               if([responseObject[kResponseStatus] isEqualToString:@"OK"] ||
                                                  [responseObject[kResponseStatus] isEqualToString:@"ZERO_RESULTS"])
                                               {
                                                   _poiDetail = [[iPOIDetailObject alloc] initWithResponse:responseObject];
                                               }
                                               else
                                               {
                                                   _poiDetail = nil;
                                               }
                                               
                                               success();
                                           }
                                           failure:^(NSError *error) {
                                               _poiDetail = nil;
                                               failure(error);
                                           }];
}

- (void) getPOIIconForCell:(UITableViewCell *)cell
                AtIndexRow:(NSInteger)indexRow
                   success:(void(^)(UIImage *image))success
                   failure:(void(^)(NSError *error))failure
{
    NSURL *iconURL = [NSURL URLWithString:[self poiIconURLStringAtIndex:indexRow]];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconURL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:60
                             ];
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:kPlaceHolderImage]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       success(image);
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       failure(error);
                                   }];
}

- (void) getPOIPhotoWithRef:(NSString *)photoRef
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;
{
    NSManagedObject *retrieveImageManagedObject = [self retrieveManagedObjectWIthID:photoRef];
    
    if (retrieveImageManagedObject)
    {
        
        NSData *imageData = [retrieveImageManagedObject valueForKey:kImageDataAttr];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [self updateImageManagedObject:retrieveImageManagedObject];
        success(image);
    }
    else
    {
        [_poiImageManager getPOIPhotoWithRef:photoRef
                                     success:^(id responseObject) {
                                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(responseObject) forKey:photoRef];
                                         [self saveImage:responseObject WithID:photoRef];
                                         success(responseObject);
                                     }
                                     failure:^(NSError *error) {
                                         failure(error);
                                     }];
    }
}

- (NSManagedObject *)retrieveManagedObjectWIthID:(NSString *)imageID
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *subs = @{@"ID" : imageID};
    NSFetchRequest *request = [appDelegate.managedObjectModel fetchRequestFromTemplateWithName:kImageWithIDRequest substitutionVariables:subs];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request
                                                                       error:&error];
    if(error == nil)
    {
        if(results.count == 0)
        {
            return nil;
        }
        
        if(results.count > 1)
        {
            NSLog(@"in DataBase %lu rows for PhotoRef <%@>", (unsigned long)results.count, imageID);
        }
        
        return [results firstObject];
    }
    else
    {
        NSLog(@"Error fetch request: %@", [error localizedDescription]);
    }
    
    return nil;
}

- (void)saveImage:(UIImage *)image WithID:(NSString *)imageID
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *newImageManagedObject = [NSEntityDescription insertNewObjectForEntityForName:kImageEntity inManagedObjectContext:context];
    
    [newImageManagedObject setValue:imageID forKey:kImageIDAttr];
    [newImageManagedObject setValue:UIImagePNGRepresentation(image) forKey:kImageDataAttr];
    [newImageManagedObject setValue:[NSDate date] forKey:kImageLastUsedAttr];
    
    [appDelegate saveContext];
}

- (void)updateImageManagedObject:(NSManagedObject *)imageManagedObject
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [imageManagedObject setValue:[NSDate date] forKey:kImageLastUsedAttr];
    
    [appDelegate saveContext];
}

@end
