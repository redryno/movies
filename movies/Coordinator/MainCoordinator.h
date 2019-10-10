//
//  MainCoordinator.h
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"

@protocol Coordinator;

NS_ASSUME_NONNULL_BEGIN

@interface MainCoordinator : NSObject <Coordinator>

@property (nonatomic) UINavigationController *navigationController;

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)start;
- (void)childDidFinish:(NSObject<Coordinator> *)child;
- (void)searchForMovie;
- (void)viewMovieDetails:(NSString *)movieId;
- (void)leaveMovieDetails;

@end

NS_ASSUME_NONNULL_END
