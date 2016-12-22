//
//  iPOIAboutController.m
//  iPOI
//
//  Created by Rigo on 21/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iPOIAboutController.h"
#import "SWRevealViewController.h"

@interface iPOIAboutController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation iPOIAboutController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
