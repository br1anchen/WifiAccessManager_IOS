//
//  WifiAccessManagerLoginViewController.h
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiAccessManagerLoginViewController : UIViewController

@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSString  *password;

@property (weak, nonatomic) IBOutlet UITextField *email_input;
@property (weak, nonatomic) IBOutlet UITextField *pwd_input;

- (IBAction)userLogin:(id)sender;
@end
