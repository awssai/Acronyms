//
//  ACNetworkLayer.m
//  Acronyms
//
//  Created by Sairam on 9/25/15.
//  Copyright (c) 2015 Sai Ram. All rights reserved.
//

#import "ACNetworkLayer.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ACNetworkLayer
+(void)fetchMeaningwithGetRequestOnURL:(NSString *)baseurl withParams:(NSDictionary *)params withResultBlock:(void (^)(id responseObject,NSError *error))result{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        result(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        result(nil,error);
    }];
}
@end
