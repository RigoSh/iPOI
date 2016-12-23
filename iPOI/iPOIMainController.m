//
//  iPOIMainController.m
//  iPOI
//
//  Created by Rigo on 08/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIMainController.h"
#import "iPOIAPI.h"
#import "SWRevealViewController.h"
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import "POIItem.h"

static NSString *const poiCellID = @"POI cell ID";
static NSString *const kDetailPOISegueID = @"detailed POI segue ID";

@interface iPOIMainController ()

@property (strong, nonatomic) IBOutlet UITableView *poiTableView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation iPOIMainController{
    CLLocationManager *_locationManager;
    iPOIAPI *_ipoiAPI;
    CLLocation *_curLocation;
    GMUClusterManager *_clusterManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchButton.layer.cornerRadius = 10;
    
    _ipoiAPI = [iPOIAPI sharedInstance];
    [_ipoiAPI poiClear];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    id<GMUClusterAlgorithm> algorithm = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id<GMUClusterIconGenerator> iconGenerator = [[GMUDefaultClusterIconGenerator alloc] init];
    id<GMUClusterRenderer> renderrer = [[GMUDefaultClusterRenderer alloc] initWithMapView:self.mapView clusterIconGenerator:iconGenerator];
    
    _clusterManager = [[GMUClusterManager alloc] initWithMap:self.mapView
                                                   algorithm:algorithm
                                                    renderer:renderrer];
    
#if TARGET_OS_SIMULATOR
    _curLocation = [[CLLocation alloc] initWithLatitude:56.32867 longitude:44.00205];
#else
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
#endif
    
    [self.mapView animateToZoom:0];
    
//    self.poiTableView.refreshControl = [UIRefreshControl new];
//    [self.poiTableView.refreshControl addTarget:self
//                                         action:@selector(updatePOIData)
//                               forControlEvents:UIControlEventValueChanged];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController)
    {
        [self.sidebarButton setTarget:revealController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if TARGET_OS_SIMULATOR
    [self locationManager:_locationManager didUpdateLocations:@[_curLocation]];
#endif

}

#pragma mark - internal functionality

- (void) clearMarkersOnMapView
{
    [self.mapView clear];
}

- (void) addMarkersOnMapView
{
//    [_clusterManager clearItems];
    
    for (NSInteger index = 0; index < [_ipoiAPI poiCount]; index++)
    {
        CLLocationCoordinate2D poiCoordinate2D = [_ipoiAPI poiCoordinate2DAtIndex:index];
        
        if(CLLocationCoordinate2DIsValid(poiCoordinate2D))
        {
//            GMSMarker *poiMarker = [[GMSMarker alloc] init];
//            poiMarker.title = [_ipoiAPI poiNameAtIndex:index];
//            poiMarker.icon = [UIImage imageNamed:@"glow-marker"];
//            poiMarker.position = poiCoordinate2D;
//            poiMarker.map = self.mapView;
            
            POIItem *item = [[POIItem alloc] initWithPosition:poiCoordinate2D
                                                         name:[_ipoiAPI poiNameAtIndex:index]];
            [_clusterManager addItem:item];
        }
    }
    
    [_clusterManager cluster];
}

- (void)updatePOIData
{
    if(!_curLocation)
    {
        return;
    }
    
    __weak UITableView *wealPOITable = self.poiTableView;
    __weak typeof(self) weakself = self;
    
    [_ipoiAPI addPOIAndFinishWithSuccess:^(BOOL haveNewPOI) {
        if (haveNewPOI)
        {
            [wealPOITable reloadData];
            
            [weakself clearMarkersOnMapView];
            [weakself addMarkersOnMapView];
        }
    } failure:^(NSError *error) {
        NSLog(@"Request error: %@", [error localizedDescription]);
    }];
    
    [self.poiTableView.refreshControl endRefreshing];
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
    [_locationManager stopUpdatingLocation];
    
    _curLocation = [locations lastObject];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_curLocation.coordinate.latitude longitude:_curLocation.coordinate.longitude zoom:14];
    [self.mapView animateToCameraPosition:camera];
}

#pragma mark - User actions

- (IBAction)startSearchingPOI:(id)sender
{
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
