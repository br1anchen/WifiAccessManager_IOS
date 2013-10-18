//
//  HttpRequestUtilities.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "HttpRequestUtilities.h"

@implementation HttpRequestUtilities


- (BOOL)loginRequest:(NSString *)email withPassword:(NSString *)pwd
{
    __block BOOL loginResult;
    
    NSString *loginUrl = @"http://129.241.200.170:8080/admin/mobile/loginapp.php";
    
    NSURL *url=[NSURL URLWithString:loginUrl];
    
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    NSString* postDataString  = [NSString stringWithFormat:@"email=%@",email];
    
    
    [requst setHTTPMethod:@"POST"];
    [requst setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [requst setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [requst setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:requst
        queue:[NSOperationQueue currentQueue]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (response) {
                NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
                NSLog(@"%d", newResp.statusCode);
                loginResult = true;
            }
            else {
                NSLog(@"No response received");
                loginResult = FALSE;
            }
    }];
    
    return loginResult;
}

@end
