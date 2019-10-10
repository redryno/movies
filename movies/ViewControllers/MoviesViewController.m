//
//  MoviesViewController.m
//  movies
//
//  Created by Ryan Bigger on 10/8/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "MoviesViewController.h"

#import "MainCoordinator.h"
#import "Movie.h"
#import "MovieTableViewCell.h"
#import "MoviesView.h"
#import <Realm/Realm.h>
#import <SDWebImage/SDWebImage.h>

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIImage *defaultImage;
@property (nonatomic) MoviesView *moviesView;
@property (nonatomic) RLMResults *movies;
@property (nonatomic) RLMNotificationToken *notification;
@property (nonatomic) NSString *yearFormat;

@end

@implementation MoviesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultImage = [UIImage imageNamed:@"DefaultPoster"];
        self.moviesView = [[MoviesView alloc] init];
        self.yearFormat = NSLocalizedString(@"Year: %@", "Year of release");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Movies", @"List of movies");
    self.view = self.moviesView;
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UITableView *tableView = self.moviesView.tableView;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (void)configureView {
    UIImage *searchImage = [UIImage systemImageNamed:@"magnifyingglass.circle.fill"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(didTapSearchButton)];
    self.navigationItem.rightBarButtonItem = searchButton;
    self.moviesView.tableView.dataSource = self;
    self.moviesView.tableView.delegate = self;

    __weak typeof(self) weakSelf = self;
    self.movies = [Movie allObjects];
    self.notification = [self.movies addNotificationBlock:^(RLMResults * _Nullable results,
                                                            RLMCollectionChange * _Nullable change,
                                                            NSError * _Nullable error) {
        if (!change) {
            [weakSelf.moviesView.tableView reloadData];
            return;
        }
        UITableView *tableView = weakSelf.moviesView.tableView;
        [tableView performBatchUpdates:^{
            [tableView reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationNone];
            [tableView deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } completion:nil];
    }];
}

#pragma mark - Actions

- (void)didTapSearchButton {
    [self.coordinator searchForMovie];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.movies.count;
    self.moviesView.emptyStateView.alpha = (count > 0) ? 0.0f : 1.0f;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MovieTableViewCell.identifier
                                                            forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:movie.imageUrl];
    if (imageURL) {
        [cell.imageView sd_setImageWithURL:imageURL placeholderImage:self.defaultImage];
    } else {
        cell.imageView.image = self.defaultImage;
    }
    cell.textLabel.text = movie.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:self.yearFormat, movie.year];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Movie *movie = self.movies[indexPath.row];
        if (movie) {
            [RLMRealm.defaultRealm transactionWithBlock:^{
                [RLMRealm.defaultRealm deleteObject:movie];
            }];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movie *movie = self.movies[indexPath.row];
    [self.coordinator viewMovieDetails:movie.objectId];
}

@end
