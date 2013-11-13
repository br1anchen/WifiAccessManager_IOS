//
//  HttpRequestUtilities.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "HttpRequestUtilities.h"
#import "AppCommonUtilities.h"
#import "JSONKit.h"
#import "Base64.h"

@implementation HttpRequestUtilities

- (BOOL)loginRequest:(NSString *)email withPassword:(NSString *)pwd
{
    
    NSString *loginUrl = [managerServerUrl stringByAppendingString:@"/admin/mobile/loginapp.php"];
    
    NSURL *url=[NSURL URLWithString:loginUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    NSString* postDataString  = [NSString stringWithFormat:@"email=%@&password=%@",[email base64EncodedString],[pwd base64EncodedString]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response){
        return TRUE;
    }else{
        return FALSE;
    }
}

- (NSData *)getRequestDevices:(NSString *)userId
{
    __block NSData *responseData;
    
    NSString *getDevicesUrl = [managerServerUrl stringByAppendingString:@"/admin/common/getclients.php"];
    
    NSURL *url=[NSURL URLWithString:getDevicesUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    NSString* postDataString  = [NSString stringWithFormat:@"user_id=%@",userId];
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    NSError *error;
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response){
        return responseData;
    }else{
        return NULL;
    }
    
}

- (BOOL)postClientAccess:(NSString *)clientName withMac:(NSString *)macAddress andStatus:(BOOL)status
{
    
    NSString *postClientUrl = [managerServerUrl stringByAppendingString:@"/admin/common/postclient.php"];
    
    NSURL *url=[NSURL URLWithString:postClientUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    
    NSString *jsonStr = [NSString stringWithFormat:@"{\"client\":{\"permissions\":{\"access\":{\"allow\":%@}},\"client_info\":{\"mac\":\"%@\",\"name\":\"%@\"}}}",status ? @"true":@"false",macAddress,clientName];
    NSDictionary *postJson = [jsonStr objectFromJSONString];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:postJson options:0 error:&error];
    [request setHTTPBody:postdata];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(response){
        return TRUE;
    }else{
        return FALSE;
    }
}

@end
