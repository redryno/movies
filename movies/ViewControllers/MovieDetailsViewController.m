//
//  MovieDetailsViewController.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "MovieDetailsViewController.h"

#import "MainCoordinator.h"
#import "DetailsView.h"
#import "Movie.h"
#import <Realm/Realm.h>
#import <SDWebImage/SDWebImage.h>

@interface MovieDetailsViewController ()

@property (nonatomic) DetailsView *detailsView;

@end

@implementation MovieDetailsViewController

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
    UIImage *minusImage = [UIImage systemImageNamed:@"minus.circle.fill"];
    UIBarButtonItem *minusButton = [[UIBarButtonItem alloc] initWithImage:minusImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(didTapMinusButton)];
    self.navigationItem.rightBarButtonItem = minusButton;
}

- (void)setMovieId:(NSString *)movieId {
    _movieId = movieId;
    NSString *yearFormat = NSLocalizedString(@"Year: %@", "Year of release");
    UIImage *defaultImage = [UIImage imageNamed:@"DefaultPoster"];

    Movie *movie = [Movie objectForPrimaryKey:self.movieId];
    NSURL *imageURL = [NSURL URLWithString:movie.imageUrl];
    if (imageURL) {
        [self.detailsView.imageView sd_setImageWithURL:imageURL placeholderImage:defaultImage];
    } else {
        self.detailsView.imageView.image = defaultImage;
    }
    self.detailsView.textLabel.text = movie.title;
    self.detailsView.detailTextLabel.text = [NSString stringWithFormat:yearFormat, movie.year];
}

- (void)didTapMinusButton {
    Movie *movie = [Movie objectForPrimaryKey:self.movieId];
    if (movie && movie.invalidated == NO) {
        [RLMRealm.defaultRealm transactionWithBlock:^{
            [RLMRealm.defaultRealm deleteObject:movie];
        }];
        [self.coordinator leaveMovieDetails];
    }
}

@end
