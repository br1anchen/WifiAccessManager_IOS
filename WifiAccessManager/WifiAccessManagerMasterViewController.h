//
//  WifiAccessManagerMasterViewController.h
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WifiAccessManagerMasterViewController;

@protocol WifiAccessManagerMasterViewControllerDelegate <NSObject>

-(void)tableViewController:(WifiAccessManagerMasterViewController *)viewController didChangeEditing:(BOOL)editing;

@end

@interface WifiAccessManagerMasterViewController : UITableViewController

@property (nonatomic, weak) id<WifiAccessManagerMasterViewControllerDelegate> delegate;

@end
