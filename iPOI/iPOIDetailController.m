//
//  iPOIDetailController.m
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIDetailController.h"
#import "iPOIAPI.h"
#import "POIPhotoCell.h"
#import <iCarousel.h>

static NSString *const poiPhotoCellID = @"POI Photo cell ID";

@interface iPOIDetailController () <iCarouselDataSource, iCarouselDelegate>


@property (weak, nonatomic) IBOutlet UITableView *poiDetailTable;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end

@implementation iPOIDetailController{
    iPOIAPI *_poiAPI;
    BOOL _dataGetSuccess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _dataGetSuccess = NO;
    self.carousel.type = iCarouselTypeRotary;

    if (!self.poiPlaceID)
    {
        NSLog(@"Error: invocation without setting <placeID> denied.");
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.poiDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.poiDetailTable.contentInset = UIEdgeInsetsZero;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _poiAPI = [iPOIAPI sharedInstance];
    
    [_poiAPI getPOIDetailWithPlaceID:self.poiPlaceID
                             success:^{
                                 _dataGetSuccess = YES;
                                 
                                 self.nameLabel.text = [_poiAPI poiDetailName];
                                 self.addressLabel.text = [_poiAPI poiDetailAddress];
                                 self.phoneLabel.text = [_poiAPI poiDetailPhone];
                                 self.ratingLabel.text = [NSString stringWithFormat: @"%@", [_poiAPI poiDetailRating]];
                                 self.openLabel.text = ([_poiAPI poiDetailOpenNow] ? @"Открыт" : @"Закрыт");
                                 
//                                 [self.poiDetailTable reloadData];
                                 [self.carousel reloadData];
                             }
                             failure:^(NSError *error) {
                                 _dataGetSuccess = NO;
                                 NSLog(@"Request error: %@", [error localizedDescription]);
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_dataGetSuccess ? 1: 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataGetSuccess)
    {
        NSInteger cnt = [_poiAPI poiDetailPhotoCount];
        return cnt;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POIPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:poiPhotoCellID
                                                         forIndexPath:indexPath];
    
    __weak POIPhotoCell *weakCell = cell;
    [_poiAPI getPOIPhotoWithRef:[_poiAPI poiDetailPhotoRefAtIndex:indexPath.row]
                        success:^(id responseObject) {
                            weakCell.photoImage = responseObject;
                            [weakCell setNeedsLayout];
                        } failure:^(NSError *error) {
                            NSLog(@"Request error: %@", [error localizedDescription]);
                        }];
    
    return cell;
}

#pragma mark - iCarousel methods

//return the total number of items in the carousel
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(_dataGetSuccess)
    {
        NSInteger cnt = [_poiAPI poiDetailPhotoCount];
        return cnt;
    }
    else
    {
        return 0;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat contentImageWidth = self.carousel.bounds.size.width*2.0f/3.0f;
    CGFloat contentImageHeight = self.carousel.bounds.size.height*2.0f/3.0f;
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentImageWidth, contentImageHeight)];
    
    __weak UIImageView *weakContentView = contentView;
    [_poiAPI getPOIPhotoWithRef:[_poiAPI poiDetailPhotoRefAtIndex:index]
                        success:^(id responseObject) {
                            weakContentView.image = responseObject;
                            weakContentView.contentMode = UIViewContentModeScaleToFill;
                            [weakContentView setNeedsLayout];
                        } failure:^(NSError *error) {
                            NSLog(@"Request error: %@", [error localizedDescription]);
                        }];
    
//    contentView.image = [UIImage imageNamed:@"PlaceHolderImage.png"]; // placeholder image
    
    return contentView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

@end
