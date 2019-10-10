//
//  SearchViewController.h
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

@property (weak, nonatomic) SearchCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END
