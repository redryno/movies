//
//  MainCoordinator.m
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "MainCoordinator.h"

#import "Coordinator.h"
#import "MovieDetailsViewController.h"
#import "MoviesViewController.h"
#import "SearchCoordinator.h"

@interface MainCoordinator()

@property (nonatomic) NSMutableArray<NSObject<Coordinator> *> *childCoordinators;

@end

@implementation MainCoordinator

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController {
    return [[self alloc] initWithNavigationController: navigationController];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
        self.childCoordinators = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)start {
    MoviesViewController *controller = [[MoviesViewController alloc] init];
    controller.coordinator = self;
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)childDidFinish:(NSObject<Coordinator> *)child {
    if ([self.childCoordinators containsObject:child]) {
        [self.childCoordinators removeObject:child];
    }
}

- (void)searchForMovie {
    UINavigationController *controller = [[UINavigationController alloc] init];
    SearchCoordinator *child = [SearchCoordinator coordinatorWithNavigationController:controller];
    child.parentCoordinator = self;
    [_childCoordinators addObject:child];
    [child start];
}

- (void)viewMovieDetails:(NSString *)movieId {
    MovieDetailsViewController *controller = [[MovieDetailsViewController alloc] init];
    controller.coordinator = self;
    controller.movieId = movieId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)leaveMovieDetails {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
