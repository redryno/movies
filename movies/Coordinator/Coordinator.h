//
//  Coordinator.h
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Coordinator

@property (nonatomic) UINavigationController *navigationController;

- (void)start;

@end
