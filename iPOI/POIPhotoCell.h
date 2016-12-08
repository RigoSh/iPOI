//
//  POIPhotoCell.h
//  iPOI
//
//  Created by Rigo on 07/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POIPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) UIImage *photoImage;

@end
