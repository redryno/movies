//
//  Movie.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : RLMObject

@property NSString *imageUrl;
@property NSString *objectId;
@property NSString *title;
@property NSString *year;


@end

NS_ASSUME_NONNULL_END
