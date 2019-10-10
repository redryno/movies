//
//  MoviesView.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "MoviesView.h"
#import "MovieTableViewCell.h"

@implementation MoviesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.systemBackgroundColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.rowHeight = 60.0f;
    [tableView registerClass:MovieTableViewCell.class forCellReuseIdentifier:MovieTableViewCell.identifier];

    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = UIColor.systemBackgroundColor;
    emptyView.alpha = 0.0f;
    emptyView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = UIColor.tertiaryLabelColor;
    emptyLabel.text = NSLocalizedString(@"No Movies", @"Movies are not available");
    emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.textColor = UIColor.tertiaryLabelColor;
    explainLabel.text = NSLocalizedString(@"Tap the search button to begin.", nil);
    explainLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:tableView];
    [self addSubview:emptyView];
    [emptyView addSubview:emptyLabel];
    [emptyView addSubview:explainLabel];

    NSLayoutConstraint *emptyLabelCenterY = [NSLayoutConstraint constraintWithItem:emptyLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:0.9
                                                                          constant:1.0];

    [NSLayoutConstraint activateConstraints: @[
        [emptyView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [emptyView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [emptyView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [emptyView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

        [emptyLabel.centerXAnchor constraintEqualToAnchor:emptyView.centerXAnchor],
        emptyLabelCenterY,

        [explainLabel.leadingAnchor constraintEqualToAnchor:emptyView.leadingAnchor constant:16.0f],
        [emptyView.trailingAnchor constraintEqualToAnchor:explainLabel.trailingAnchor constant:16.0f],
        [explainLabel.topAnchor constraintEqualToAnchor:emptyLabel.bottomAnchor constant:2.0f],

        [tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
       ]
    ];

    self.tableView = tableView;
    self.emptyStateView = emptyView;
}

@end
