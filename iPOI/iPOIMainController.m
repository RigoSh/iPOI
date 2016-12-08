//
//  iPOIMainController.m
//  iPOI
//
//  Created by Rigo on 08/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIMainController.h"
#import "iPOIAPI.h"

static NSString *const poiCellID = @"POI cell ID";
static NSString *const kDetailPOISegueID = @"detailed POI segue ID";

@interface iPOIMainController ()

@property (strong, nonatomic) IBOutlet UITableView *poiTableView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation iPOIMainController{
    CLLocationManager *_locationManager;
    iPOIAPI *_ipoiAPI;
    CLLocation *_curLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ipoiAPI = [iPOIAPI sharedInstance];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    [self.mapView animateToZoom:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal functionality

- (void) clearMarkersOnMapView
{
    [self.mapView clear];
}

- (void) addMarkersOnMapView
{
    for (NSInteger index = 0; index < [_ipoiAPI poiCount]; index++)
    {
        CLLocationCoordinate2D poiCoordinate2D = [_ipoiAPI poiCoordinate2DAtIndex:index];
        
        if(CLLocationCoordinate2DIsValid(poiCoordinate2D))
        {
            GMSMarker *poiMarker = [[GMSMarker alloc] init];
            poiMarker.title = [_ipoiAPI poiNameAtIndex:index];
            poiMarker.icon = [UIImage imageNamed:@"glow-marker"];
            poiMarker.position = poiCoordinate2D;
            poiMarker.map = self.mapView;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ipoiAPI poiCount];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiCellID
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [_ipoiAPI poiNameAtIndex:indexPath.row];
    
    __weak UITableViewCell *weakCell = cell;
    
    [_ipoiAPI getPOIIconForCell:cell
                     AtIndexRow:indexPath.row
                        success:^(UIImage *image) {
                            weakCell.imageView.image = image;
                            [weakCell setNeedsLayout];
                        } failure:^(NSError *error) {
                            NSLog(@"Request error: %@", [error localizedDescription]);
                        }];
    
    return cell;
}

#pragma mark - Location events

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    [_locationManager stopUpdatingLocation];
//    [self clearMarkersOnMapView];
    
    _curLocation = [locations lastObject];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_curLocation.coordinate.latitude longitude:_curLocation.coordinate.longitude zoom:14];
    [self.mapView animateToCameraPosition:camera];    
}

#pragma mark - User actions

- (IBAction)startUpdateLocation:(id)sender
{
//    [_locationManager requestWhenInUseAuthorization];
//    [_locationManager startUpdatingLocation];
    
    if(!_curLocation)
    {
        return;
    }
    
    [self clearMarkersOnMapView];
    
    __weak UITableView *poiTable = self.poiTableView;
    
    [_ipoiAPI getPOIAtLocation:_curLocation
                       success:^{
                           [poiTable reloadData];
                           [self addMarkersOnMapView];
                       } failure:^(NSError *error) {
                           NSLog(@"Request error: %@", [error localizedDescription]);
                           [poiTable reloadData];
                       }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kDetailPOISegueID])
    {
        UIViewController *destController = [segue destinationViewController];
        SEL selector = NSSelectorFromString(@"setPoiPlaceID:");
        
        if([destController respondsToSelector:selector])
        {
            NSIndexPath *indexPath = [self.poiTableView indexPathForCell:sender];
            NSInteger index = indexPath.row;
            
            NSString *poiPlaceID = [_ipoiAPI poiPlaceIDAtIndex:index];
            
            [destController setValue:poiPlaceID forKey:@"poiPlaceID"];
        }
    }
}

@end
