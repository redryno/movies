//
//  Movie.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+ (NSString *)primaryKey {
    return @"objectId";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"objectId": [[NSUUID UUID] UUIDString]};
}

@end
