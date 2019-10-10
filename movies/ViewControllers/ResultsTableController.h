//
//  ResultsTableController.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ResultsTableDelegate

- (void)didSelectSearchResult:(NSDictionary *)searchResult;

@end


@interface ResultsTableController : UITableViewController

@property (weak, nonatomic) UIViewController<ResultsTableDelegate> *delegate;
@property (nonatomic) NSArray<NSDictionary *> *searchResults;
@property (nonatomic) NSString *searchTerm;

@end

NS_ASSUME_NONNULL_END
