//
//  iPOITableController.m
//  iPOI
//
//  Created by Rigo on 05/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOITableController.h"
#import "iPOIAPI.h"
#import <UIImageView+AFNetworking.h>

static NSString *const poiCellID = @"POI cell ID";
static NSString *const kPlaceHolderImage = @"PlaceHolderImage.png";

@interface iPOITableController ()

@property (strong, nonatomic) IBOutlet UITableView *poiTableView;

@end

@implementation iPOITableController{
    CLLocationManager *_locationManager;
    iPOIAPI *_ipoiAPI;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ipoiAPI = [iPOIAPI sharedInstance];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ipoiAPI poiCount];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiCellID
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [_ipoiAPI poiNameAtIndex:indexPath.row];
    
    NSURL *iconURL = [NSURL URLWithString:[_ipoiAPI poiIconURLStringAtIndex:indexPath.row]];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconURL];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:kPlaceHolderImage]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"Request error: %@", [error localizedDescription]);
                                   }];
    
    return cell;
}

#pragma mark - Location events

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    
    __weak UITableView *poiTable = self.poiTableView;
    
    [_ipoiAPI getPOIAtLocation:newLocation
                       success:^{
                           [poiTable reloadData];
                       } failure:^(NSError *error) {
                           NSLog(@"Request error: %@", [error localizedDescription]);
                           [poiTable reloadData];
                       }];
}

#pragma mark - User actions

- (IBAction)startUpdateLocation:(id)sender
{
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destController = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.poiTableView indexPathForCell:sender];
    NSInteger rowIndex = indexPath.row;
    
    [destController setValue:@(rowIndex) forKey:@"poiIndex"];
}

@end
