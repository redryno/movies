//
//  SceneDelegate.h
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCoordinator;

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) MainCoordinator *coordinator;
@property (strong, nonatomic) UIWindow * window;

@end

