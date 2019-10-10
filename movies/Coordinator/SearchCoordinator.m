//
//  SearchCoordinator.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "SearchCoordinator.h"

#import "Coordinator.h"
#import "MainCoordinator.h"
#import "SearchDetailsViewController.h"
#import "SearchViewController.h"

@implementation SearchCoordinator

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController {
    return [[self alloc] initWithNavigationController: navigationController];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

- (void)start {
    SearchViewController *controller = [[SearchViewController alloc] init];
    controller.coordinator = self;
    [self.navigationController pushViewController:controller animated:NO];
    if (self.parentCoordinator != nil) {
        UIViewController *visibleController = self.parentCoordinator.navigationController.visibleViewController;
        if (visibleController != nil) {
            [visibleController presentViewController:self.navigationController animated:YES completion:nil];
        }
    }
}

- (void)didFinishSeaching {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.parentCoordinator childDidFinish:self];
}

- (void)leaveSearchDetails {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewSearchDetails:(NSDictionary *)searchResult {
    SearchDetailsViewController *controller = [[SearchDetailsViewController alloc] init];
    controller.searchResult = searchResult;
    controller.coordinator = self;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
