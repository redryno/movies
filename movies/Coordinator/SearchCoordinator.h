//
//  SearchCoordinator.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"

@class MainCoordinator;

NS_ASSUME_NONNULL_BEGIN

@interface SearchCoordinator : NSObject <Coordinator>

@property (nonatomic) MainCoordinator *parentCoordinator;
@property (nonatomic) UINavigationController *navigationController;

+ (instancetype)coordinatorWithNavigationController:(UINavigationController *)navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)start;
- (void)didFinishSeaching;
- (void)leaveSearchDetails;
- (void)viewSearchDetails:(NSDictionary *)searchResult;

@end

NS_ASSUME_NONNULL_END
