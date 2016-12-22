//
//  iPOIPlaceController.m
//  iPOI
//
//  Created by Rigo on 09/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIPlaceController.h"
#import <GooglePlacePicker/GooglePlacePicker.h>
#import "SWRevealViewController.h"

@interface iPOIPlaceController () <GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityGeoLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *placePhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *placeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation iPOIPlaceController{
    GMSPlacePicker *_placePicker;
    GMSPlace *_selectedCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController)
    {
        [self.sidebarButton setTarget:revealController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
    
    self.placeButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User interactions

- (IBAction)citySearchTapped:(id)sender
{
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    filter.accessibilityLanguage = @"ru";
    
    GMSAutocompleteViewController *acContoller = [[GMSAutocompleteViewController alloc] init];
    acContoller.delegate = self;
    acContoller.autocompleteFilter = filter;
    
    [self presentViewController:acContoller animated:YES completion:nil];
}

- (IBAction)placeSearchTapped:(id)sender
{
    if(_selectedCity == nil)
    {
        return;
    }
    
    CLLocationCoordinate2D center = _selectedCity.coordinate;
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];;
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        if(error != nil)
        {
            NSLog(@"Pick place error: %@", [error localizedDescription]);
        }
        
        if(result != nil)
        {
            self.placeNameLabel.text = result.name;
            self.placeAddressLabel.text = [[result.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            self.placePhoneLabel.text = result.phoneNumber;
        }
        else
        {
            self.placeNameLabel.text = @"";
            self.placeAddressLabel.text = @"";
            self.placePhoneLabel.text = @"";
        }
    }];
}

#pragma mark - GMSAutocompleteViewController Delegate

- (void) viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    _selectedCity = place;
    
    self.cityNameLabel.text = _selectedCity.name;
    self.cityGeoLocationLabel.text = _selectedCity.formattedAddress;
    self.placeNameLabel.text = @"";
    self.placeAddressLabel.text = @"";
    self.placePhoneLabel.text = @"";
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.placeButton.hidden = NO;
}

- (void) viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
