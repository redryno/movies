//
//  MovieDetailsViewController.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailsViewController : UIViewController

@property (nonatomic) NSString *movieId;
@property (weak, nonatomic) MainCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END
