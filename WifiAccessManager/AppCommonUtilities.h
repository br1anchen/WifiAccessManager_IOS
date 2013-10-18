//
//  AppCommonUtilities.h
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCommonUtilities : NSObject
{
    NSString *URL_SERVER;
}

@property(nonatomic,retain)NSString *URL_SERVER;

+(AppCommonUtilities*)getInstance;

@end
