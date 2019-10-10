//
//  MoviesViewController.h
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface MoviesViewController : UIViewController

@property (weak, nonatomic) MainCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END
