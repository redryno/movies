//
//  ResultsTableController.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "ResultsTableController.h"

#import "Constants.h"
#import "MovieTableViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface ResultsTableController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UIImage *defaultImage;
@property (nonatomic) NSString *yearFormat;

@end

@implementation ResultsTableController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultImage = [UIImage imageNamed:@"DefaultPoster"];
        self.yearFormat = NSLocalizedString(@"Year: %@", "Year of release");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:MovieTableViewCell.class forCellReuseIdentifier:MovieTableViewCell.identifier];
}

- (void)setSearchResults:(NSArray *)searchResults {
    _searchResults = searchResults;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MovieTableViewCell.identifier forIndexPath:indexPath];
    NSDictionary *result = self.searchResults[indexPath.row];

    cell.textLabel.text = result[resultsKeyTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:self.yearFormat, result[resultsKeyYear]];

    NSURL *imageURL = result[resultsKeyImageURL];
    if (imageURL) {
        [cell.imageView sd_setImageWithURL:result[resultsKeyImageURL] placeholderImage:self.defaultImage];
    } else {
        cell.imageView.image = self.defaultImage;
    }

    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *searchResult = self.searchResults[indexPath.row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectSearchResult:)]) {
        [self.delegate didSelectSearchResult:searchResult];
    }
}

@end
