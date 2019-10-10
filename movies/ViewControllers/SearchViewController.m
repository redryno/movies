//
//  SearchViewController.m
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "SearchViewController.h"

#import "APIConnect.h"
#import "Constants.h"
#import "ResultsTableController.h"
#import "SearchCoordinator.h"

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, ResultsTableDelegate>

@property (nonatomic) APIConnect *apiConnect;
@property (nonatomic) NSDate *lastSearchAt;
@property (nonatomic) ResultsTableController *resultsTableController;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) NSTimer *timer;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = NSLocalizedString(@"Find A Movie", @"Find a movie in the database");
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UITableView *tableView = self.resultsTableController.tableView;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (APIConnect *)apiConnect {
    if (_apiConnect != nil) {
        return _apiConnect;
    }
    _apiConnect = [[APIConnect alloc] init];
    return _apiConnect;
}

- (void)configureView {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Go back")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Finished view")
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(didTapDoneButton)];

    self.resultsTableController = [[ResultsTableController alloc] init];
    self.resultsTableController.delegate = self;

    self.lastSearchAt = [NSDate distantPast];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;

    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.searchController = self.searchController;
}

#pragma mark - Actions

- (void)didSelectSearchResult:(NSDictionary *)searchResult {
    [self.searchController.searchBar resignFirstResponder];
    [self.coordinator viewSearchDetails:searchResult];
}

- (void)didTapDoneButton {
    [self.coordinator didFinishSeaching];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)displayError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Search Error", @"Searching cause an error");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:error.localizedDescription
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Accept and close")
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)getMoviesWithTitle:(NSString *)title {
    // Use the base URL to search for the specified title
    [self.apiConnect GET:@"/"
              parameters:@{@"s": title}
              completion:^(id  _Nullable jsonObject, NSData * _Nullable data, NSError * _Nullable error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (error) {
                          [self displayError:error];
                          return;
                      }

                      // Pass the results to the results controller
                      self.resultsTableController.searchResults = [self parseResponse:jsonObject];
                      self.resultsTableController.searchTerm = title;
                      self.lastSearchAt = [NSDate date];
                  });
    }];
}

- (NSArray *)parseResponse:(NSDictionary *)response {
    // Verify results were returned
    NSMutableArray *results = [NSMutableArray array];
    if (response == nil || ![response isKindOfClass:NSDictionary.class]) {
        return results;
    }

    // Verify the results contains a key called "Search"
    NSArray<NSMutableDictionary *> *search = response[resultsKeyResults];
    if (search == nil || ![search isKindOfClass:NSArray.class]) {
        return results;
    }

    // Loop through each results and verify a title, year, and poster exist
    [search enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *keysForNullValues = [obj allKeysForObject:[NSNull null]];
        [obj removeObjectsForKeys:keysForNullValues];

        if (!obj[resultsKeyTitle]) {
            return;
        }

        if (!obj[resultsKeyYear]) {
            obj[resultsKeyYear] = @"Unknown";
        }

        NSURL *url = [NSURL URLWithString:obj[resultsKeyPoster]];
        if (url && url.scheme && url.host) {
            obj[resultsKeyImageURL] = url;
        }
        [results addObject:obj];
    }];
    return results;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *title = [searchController.searchBar.text stringByTrimmingCharactersInSet:characterSet];
    if (title.length < 2 || [title isEqualToString:self.resultsTableController.searchTerm]) {
        // Title should be 2 or more characters
        // Title should not matche the results current being displayed
        return;
    }

    // Create an invocation to be executed when the timer fires
    SEL selector = @selector(getMoviesWithTitle:);
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&title atIndex:2];

    // If the user pauses for 0.3 seconds attempt a search,
    // but never fire more than one search per second
    [self.timer invalidate];
    NSTimeInterval interval = [self.lastSearchAt timeIntervalSinceNow];
    NSTimeInterval duration = (interval > -1) ? (1 + interval) : 0.3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration invocation:invocation repeats:NO];
}

@end
