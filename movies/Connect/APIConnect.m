//
//  APIConnect.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "APIConnect.h"
#import "Constants.h"

@interface APIConnect ()

@property (nonatomic) NSURLSession *session;

@end

@implementation APIConnect

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseURL = [NSURL URLWithString:BASE_URL];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (NSString *)urlEncodedStringForParameters:(NSDictionary *)parameters {
    NSMutableCharacterSet *chars = NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy;
    [chars removeCharactersInRange:NSMakeRange('&', 1)];
    [chars removeCharactersInRange:NSMakeRange(':', 1)];

    NSMutableArray *keyValue = [NSMutableArray array];
    for (NSString *key in parameters.allKeys){
        id value = parameters[key];
        if ([value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSArray.class]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if ([value isKindOfClass:NSNumber.class]) {
            value = [value stringValue];
        }
        NSString *encoded = [value stringByAddingPercentEncodingWithAllowedCharacters:chars];
        [keyValue addObject:[NSString stringWithFormat:@"%@=%@", key, encoded]];
    }
    return [NSString stringWithFormat:@"?%@", [keyValue componentsJoinedByString:@"&"]];
}

- (void)GET:(NSString *)endpoint parameters:(NSDictionary *)parameters completion:(APIConnectCallback)callback {
    if (endpoint == nil) {
        return;
    }

    // Add the API Key
    NSMutableDictionary *includedKey = [NSMutableDictionary dictionaryWithDictionary:parameters];
    includedKey[@"apikey"] = API_KEY;

    // Build the parameters that will appear in the query
    NSMutableString *parameterString = [NSMutableString stringWithString:endpoint];
    [parameterString appendString:[self urlEncodedStringForParameters:includedKey]];

    [self dataTaskWithURL:[NSURL URLWithString:parameterString relativeToURL:self.baseURL]
                   method:@"GET"
               parameters:nil
               completion:callback];
}

- (void)dataTaskWithURL:(NSURL *)url method:(NSString *)method parameters:(id)parameters completion:(APIConnectCallback)callback {
    if (callback == nil) {
        callback = ^(id obj, id obj2, id obj3) { /* does nothing */ };
    }

    if (url == nil) {
        NSString *message = NSLocalizedString(@"Invalid URL: (nil)", @"URL is not valid");
        NSDictionary *errorData = @{NSLocalizedDescriptionKey: message};
        NSError *error = [[NSError alloc] initWithDomain:kRBErrorDomain code:204 userInfo:errorData];
        callback(nil, nil, error);
        return;
    }

    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:40.0];
    request.HTTPMethod = method;
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [[self.session dataTaskWithRequest:request
                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        [self JSONObjectWithData:data
                                        response:response
                                           error:error
                                      completion:^(id _Nullable jsonObject, NSData * _Nullable data, NSError * _Nullable error) {
                                          callback(jsonObject, data, error);
                                      }];
    }] resume];
}

- (void)JSONObjectWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error completion:(APIConnectCallback)callback {
    if (error) {
        callback(nil, data, error); // Unable to connect to server error
        return;
    }

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 204 || data.length == 0) {
        callback(@{}, data, nil); // No content response
        return;

    } else if (httpResponse.statusCode == 401) {
        NSDictionary *errorData = @{NSLocalizedDescriptionKey : @"Not Authorized"};
        error = [[NSError alloc] initWithDomain:kRBErrorDomain code:401 userInfo:errorData];
        callback(nil, data, error); // Not authorized
        return;
    }

    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                error:&error];
    if (error) {
        callback(nil, data, error); // JSON parse error
        return;
    }

    if ([json isKindOfClass:NSDictionary.class]) {
        callback(json, data, nil); // Return dictionary

    } else if ([json isKindOfClass:NSArray.class]) {
        callback(json, data, nil); // Return array

    } else {
        callback(@{@"response": json}, data, nil); // Return unknown object
    }
}

@end
