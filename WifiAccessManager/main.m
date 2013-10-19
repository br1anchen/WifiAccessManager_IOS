//
//  main.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WifiAccessManagerAppDelegate.h"

NSString *managerServerUrl = @"http://129.241.200.170:8080";

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([WifiAccessManagerAppDelegate class]));
    }
}
