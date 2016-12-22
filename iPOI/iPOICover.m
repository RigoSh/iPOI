//
//  iPOICover.m
//  iPOI
//
//  Created by Rigo on 22/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOICover.h"
#import <SGProgressIndicator.h>

@interface iPOICover ()

@end

@implementation iPOICover

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger min = 2, max = 4;
    NSTimeInterval interval = min + arc4random() % (max - min);
    
    [self performSelector:@selector(showMainPage)
               withObject:nil
               afterDelay:interval];
}

- (void)showMainPage
{
    [self performSegueWithIdentifier:@"coverToMain" sender:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
