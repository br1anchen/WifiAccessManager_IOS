//
//  HttpRequestUtilities.h
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestUtilities : NSObject

- (BOOL)loginRequest:(NSString *)email withPassword:(NSString *)pwd;
- (NSData *)getRequestDevices:(NSString *)userId;
- (BOOL)postClientAccess:(NSString *)clientName withMac:(NSString *)macAddress andStatus:(BOOL)status;
@end
