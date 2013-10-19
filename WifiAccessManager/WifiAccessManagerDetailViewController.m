//
//  WifiAccessManagerDetailViewController.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "WifiAccessManagerDetailViewController.h"

@interface WifiAccessManagerDetailViewController ()
- (void)configureView;
@end

@implementation WifiAccessManagerDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSString *detailInfo = [NSString stringWithFormat:@"%@:%@, Access: %@",[self.detailItem objectForKey:@"request Name"],[self.detailItem objectForKey:@"request Mac"],[self.detailItem objectForKey:@"request Result"] ? @"Yes" : @"No"];
        self.detailDescriptionLabel.text = detailInfo;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
