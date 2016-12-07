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

static NSString *const poiPhotoCellID = @"POI Photo cell ID";

@interface iPOIDetailController ()

@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *nameText;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation iPOIDetailController{
    iPOIAPI *_poiAPI;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _poiAPI = [iPOIAPI sharedInstance];
    
    self.nameText.text = [_poiAPI poiNameAtIndex:self.poiIndex];
    self.addressText.text = [_poiAPI poiAddressAtIndex:self.poiIndex];
    self.ratingLabel.text = [NSString stringWithFormat: @"%@", [_poiAPI poiRatingAtIndex:self.poiIndex]];
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
    NSInteger cnt = [_poiAPI poiPhotoCountAtIndex:self.poiIndex];
    
    return cnt;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POIPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:poiPhotoCellID
                                                         forIndexPath:indexPath];
    
    __weak POIPhotoCell *weakCell = cell;
    [_poiAPI getPOIPhotoWithRef:[_poiAPI poiPhotoRefPOIAtIndex:self.poiIndex
                                               andPhotoAtIndex:indexPath.row]
                        success:^(id responseObject) {
                            weakCell.photoImage = responseObject;
                            [weakCell setNeedsLayout];
                        } failure:^(NSError *error) {
                            NSLog(@"Request error: %@", [error localizedDescription]);
                        }];

    return cell;
}

@end
