//
//  UAGithubURLConnection.m
//  UAGithubEngine
//
//  Created by Owain Hunt on 26/04/2010.
//  Copyright 2010 Owain R Hunt. All rights reserved.
//

#import "UAGithubURLConnection.h"
#import "NSString+UUID.h"


@implementation UAGithubURLConnection

@synthesize data, requestType, responseType, identifier;

+ (id)asyncRequest:(NSURLRequest *)request success:(id(^)(NSData *, NSURLResponse *))successBlock failure:(id(^)(NSError *))failureBlock_ 
{
    @autoreleasepool
    {    
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error) {
            return failureBlock_(error);
        } else {
            return successBlock(data,response);
        }
    }
}

+ (id)asyncRequest:(NSURLRequest *)request success:(id(^)(NSData *, NSURLResponse *))successBlock error:(NSError *__strong *)error
{
    @autoreleasepool
    {    
        NSURLResponse *response = nil;
        NSError *connectionError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
        
        if (connectionError) {
            *error = connectionError;
            return nil;
        } else {
            return successBlock(data,response);
        }
    }
}

@end
