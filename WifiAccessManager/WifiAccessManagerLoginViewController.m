//
//  WifiAccessManagerLoginViewController.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "WifiAccessManagerLoginViewController.h"

@interface WifiAccessManagerLoginViewController ()

@end

@implementation WifiAccessManagerLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogin:(id)sender {
    self.email = self.email_input.text;
    self.password = self.pwd_input.text;
    NSString *loginInfo = [NSString stringWithFormat:@"WifiAccess Manager:Login:email: %@, pwd: %@",self.email,self.password];
    NSLog(@"%@", loginInfo);
}
@end
