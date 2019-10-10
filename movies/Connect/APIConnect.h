//
//  APIConnect.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIConnect : NSObject

typedef void (^APIConnectCallback)(id _Nullable jsonObject, NSData * _Nullable data, NSError * _Nullable error);
@property (nonatomic) NSURL *baseURL;

- (void)GET:(NSString *)endpoint parameters:(NSDictionary *)parameters completion:(APIConnectCallback)callback;

@end

NS_ASSUME_NONNULL_END
