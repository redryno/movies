//
//  SearchDetailsViewController.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface SearchDetailsViewController : UIViewController

@property (nonatomic) NSDictionary *searchResult;
@property (weak, nonatomic) SearchCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END
