//
//  MoviesView.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoviesView : UIView

@property (nonatomic) UIView *emptyStateView;
@property (nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
