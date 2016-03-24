//
//  NetworkManager.m
//  twitterReader
//
//  Created by Katekov Anton on 05.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "NetworkManager.h"



static NetworkManager *g_instance;



@implementation NetworkManager

+ (NetworkManager *)instance
{
    if (!g_instance) {
        g_instance = [[self alloc] init];
    }
    return g_instance;
}

- (SLRequest *)GET:(NSString *)URLString
        parameters:(id)parameters
           success:(void (^)(SLRequest *request, id response))success
           failure:(void (^)(SLRequest *request, NSError *error))failure
{
    NSLog(@"posting request");
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:URLString]
                                               parameters:parameters];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {

        // todo: temporary stub
//        if (responseData.length < 100) {
//            responseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stub" ofType:@"txt"]];
//            NSLog(@"presenting stub!!!");
//        }
        
        NSError *jsonError = nil;
        id responseJSON = nil;
        if (responseData) {
            NSError *jsonError = nil;
            responseJSON = [NSJSONSerialization
                            JSONObjectWithData:responseData
                            options:NSJSONReadingAllowFragments
                            error:&jsonError];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if (error && !responseJSON)
                           {
                               failure (request, error);
                           }
                           else
                           {
                               if (jsonError) {
                                   failure (request, jsonError);
                                   return;
                               }
                               
                               if ([responseJSON respondsToSelector:@selector(objectForKey:)] &&
                                   [responseJSON objectForKey:@"errors"])
                               {
                                   failure (request, [NSError errorWithDomain:@"twitter error" code:400 userInfo:[responseJSON objectForKey:@"errors"][0]
                                                      ]);
                                   return;
                               }
                               
                               success (request, responseJSON);
                           }
                       });
        
    }];
    
    return request;
}

@end


