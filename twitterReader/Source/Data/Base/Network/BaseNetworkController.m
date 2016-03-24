//
//  BaseNetworkController.m
//  twitterReader
//
//  Created by Katekov Anton on 05.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "BaseNetworkController.h"
#import "NetworkManager.h"



NSString *kRequestMethodGET = @"kRequestMethodGET";



@implementation BaseNetworkController

- (id)init
{
    if (self = [super init]) {
        _requests = [NSMutableArray array];
    }
    return self;
}

- (void)sendRequrestWithMethod:(NSString*)method
                     URLString:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(id responseObject, NSString *requstURL))success
                       failure:(void (^)(NSError *error, NSString *requstURL))failure
{
    SLRequest *result = nil;
    NetworkManager *manager = [NetworkManager instance];
    
    if ([method isEqualToString:kRequestMethodGET])
    {
        result = [manager GET:URLString
                   parameters:parameters
                      success:^(SLRequest *request, id response)
                  {
                      [_requests removeObject:request];
                      id responseObject = [self handleSuccessResponce:response forRequestURL:URLString];
                      if (success)
                          success(responseObject, URLString);
                  }
                      failure:^(SLRequest *request, NSError *error)
                  {
                      [_requests removeObject:request];
                      [self handleError:error forRequest:request];
                      if (failure)
                          failure(error, URLString);
                  }];
    }
    
    [_requests addObject:result];
}

- (void)handleError:(NSError*)error forRequest:(SLRequest *)request
{
    //do something
}

- (id)handleSuccessResponce:(id)responce forRequestURL:(NSString*)requestURL
{
    return [self performMappingForResponce:responce forRequsetURL:requestURL];
}

- (id)performMappingForResponce:(id)responce forRequsetURL:(NSString*)requestURL
{
    if (responce)
    {
        id<MappableObject> object = [self makeResultObjectForRequsetURL:requestURL];
        [object readFromDictionaryRepresentation:responce];
        return object;
    }
    else
        return nil;
}

- (id<MappableObject>)makeResultObjectForRequsetURL:(NSString*)requestURL
{
    return nil;
}

- (BOOL)isLoading
{
    return _requests.count > 0;
}

@end
