//
//  SearchDetailsViewController.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "SearchDetailsViewController.h"

#import "SearchCoordinator.h"
#import "Constants.h"
#import "DetailsView.h"
#import "Movie.h"
#import <Realm/Realm.h>
#import <SDWebImage/SDWebImage.h>

@interface SearchDetailsViewController ()

@property (nonatomic) DetailsView *detailsView;

@end

@implementation SearchDetailsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.detailsView = [[DetailsView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Details", @"Details about a movie");
    self.view = self.detailsView;
    [self configureView];
}

- (void)configureView {
    UIImage *plusImage = [UIImage systemImageNamed:@"plus.circle.fill"];
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithImage:plusImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapPlusButton)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)setSearchResult:(NSDictionary *)searchResult {
    _searchResult = searchResult;
    NSString *yearFormat = NSLocalizedString(@"Year: %@", "Year of release");
    UIImage *defaultImage = [UIImage imageNamed:@"DefaultPoster"];   

    NSURL *imageURL = self.searchResult[resultsKeyImageURL];
    if (imageURL) {
        [self.detailsView.imageView sd_setImageWithURL:self.searchResult[resultsKeyImageURL] placeholderImage:defaultImage];
    } else {
        self.detailsView.imageView.image = defaultImage;
    }
    self.detailsView.textLabel.text = self.searchResult[resultsKeyTitle];
    self.detailsView.detailTextLabel.text = [NSString stringWithFormat:yearFormat, self.searchResult[resultsKeyYear]];
}

- (void)didTapPlusButton {
    Movie *movie = [[Movie alloc] init];
    movie.title = self.searchResult[resultsKeyTitle];
    movie.year = self.searchResult[resultsKeyYear];
    movie.imageUrl = self.searchResult[resultsKeyPoster];
    [RLMRealm.defaultRealm transactionWithBlock:^{
        [RLMRealm.defaultRealm addObject:movie];
    }];
    [self.detailsView showSuccess:^(BOOL finished) {
        [self.coordinator leaveSearchDetails];
    }];
}

@end
