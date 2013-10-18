//
//  AppCommonUtilities.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "AppCommonUtilities.h"

@implementation AppCommonUtilities

@synthesize URL_SERVER;

static AppCommonUtilities *instance =nil;

+(AppCommonUtilities *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [AppCommonUtilities new];
        }
    }
    return instance;
}

@end
