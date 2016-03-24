//
//  BaseNetworkController.h
//  twitterReader
//
//  Created by Katekov Anton on 05.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "MappableObject.h"



extern NSString *kRequestMethodGET;


/*
 *Incapsulating the Twitter api
 */
@interface BaseNetworkController : NSObject {
    
    NSMutableArray<__kindof SLRequest*> *_requests;

}

@property (nonatomic, readonly) BOOL isLoading;

//TODO make post object method

/*
 *Creates and runs request.
 *
 *@param method The request method.
 *@param URLString The URL string used to create the request URL.
 *@param parameters The parameters of the request
 *@param success A block object to be executed when the task finishes successfully. This block has no return
 *value and takes two arguments: the data task, and the response object created by the overriden makeResultObjectForRequsetURL method.
 *@param failure A block object to be executed when the task finishes unsuccessfully
 */
- (void)sendRequrestWithMethod:(NSString*)method
                     URLString:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(id responseObject, NSString *requstURL))success
                       failure:(void (^)(NSError *error, NSString *requstURL))failure;

/*
 *Handle error of request
 */
- (void)handleError:(NSError*)error forRequest:(SLRequest *)request;

/*
 *Handle success result of request, preform mapping of result
 *
 *@return by-default it is a result of method `performMappingForResponce: forRequsetUrl:`
 */
- (id)handleSuccessResponce:(id)responce forRequestURL:(NSString*)requestURL;

/*
 *Perform mapping operation.
 *
 *@return mapped object. this object will be sent to completion handler
 */
- (id)performMappingForResponce:(id)responce forRequsetURL:(NSString*)requestURL;

/*
 *Override this method
 *
 *Creates an instance of object which you expect from thus `requestURL`.
 *This instance will be mapped with resonce.
 *
 *@return mappable object which you expect from this `requestURL`
 */
- (id<MappableObject>)makeResultObjectForRequsetURL:(NSString*)requestURL;

@end
