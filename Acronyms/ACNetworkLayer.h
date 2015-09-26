//
//  ACNetworkLayer.h
//  Acronyms
//
//  Created by Sairam on 9/25/15.
//  Copyright (c) 2015 Sai Ram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACNetworkLayer : NSObject
+(void)fetchMeaningwithGetRequestOnURL:(NSString *)baseurl withParams:(NSDictionary *)params withResultBlock:(void (^)(id responseObject,NSError *error))result;
@end
