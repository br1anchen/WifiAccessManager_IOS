//
//  HttpRequestUtilities.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "HttpRequestUtilities.h"
#import "AppCommonUtilities.h"

@implementation HttpRequestUtilities

- (BOOL)loginRequest:(NSString *)email withPassword:(NSString *)pwd
{
    __block BOOL loginResult;
    
    NSString *loginUrl = [managerServerUrl stringByAppendingString:@"/admin/mobile/loginapp.php"];
    
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
                NSLog(@"%ld", (long)newResp.statusCode);
                loginResult = true;
            }
            else {
                NSLog(@"No response received");
                loginResult = FALSE;
            }
    }];
    
    return loginResult;
}

- (NSData *)getRequestDevices:(NSString *)userId
{
    __block NSData *responseData;
    
    NSString *getDevicesUrl = [managerServerUrl stringByAppendingString:@"/admin/common/getclients.php"];
    
    NSURL *url=[NSURL URLWithString:getDevicesUrl];
    
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    NSString* postDataString  = [NSString stringWithFormat:@"user_id=%@",userId];
    
    
    [requst setHTTPMethod:@"POST"];
    [requst setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [requst setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [requst setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    NSError *error;
    
    responseData = [NSURLConnection sendSynchronousRequest:requst returningResponse:&response error:&error];
    
    if(response){
        return responseData;
    }else{
        return NULL;
    }
    
}

@end
