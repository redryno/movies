//
//  DetailsView.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "DetailsView.h"

@implementation DetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.systemBackgroundColor;
        self.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIStackView *vStack = [[UIStackView alloc] init];
    vStack.axis = UILayoutConstraintAxisVertical;
    vStack.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, 16.0f, 0, 0);
    vStack.distribution = UIStackViewDistributionEqualCentering;
    vStack.layoutMarginsRelativeArrangement = YES;
    vStack.spacing = 2.0f;
    vStack.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"DefaultPosterLarge"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textLabel.numberOfLines = 0;
    textLabel.textColor = UIColor.labelColor;
    textLabel.text = @"Superman";

    UILabel *detailTextLabel = [[UILabel alloc] init];
    detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    detailTextLabel.textColor = UIColor.secondaryLabelColor;
    detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Year: %@", "Year of release"), @"2007"];

    [self addSubview:imageView];
    [self addSubview:vStack];
    [vStack addArrangedSubview:textLabel];
    [vStack addArrangedSubview:detailTextLabel];

    UILayoutGuide *margins = self.layoutMarginsGuide;
    [NSLayoutConstraint activateConstraints:@[
       [imageView.topAnchor constraintEqualToAnchor:margins.topAnchor],
       [imageView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
       [imageView.widthAnchor constraintEqualToConstant:60],
       [imageView.heightAnchor constraintEqualToConstant:100],

       [vStack.topAnchor constraintGreaterThanOrEqualToAnchor:margins.topAnchor],
       [vStack.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor],
       [vStack.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
       [vStack.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor]
       ]
    ];

    self.imageView = imageView;
    self.textLabel = textLabel;
    self.detailTextLabel = detailTextLabel;
}

- (void)showSuccess:(void (^)(BOOL finished))callback {
    if (self.successView) {
        [self animateInSuccess:callback];
        return;
    }

    UIView *container = [[UIView alloc] init];
    container.alpha = 0;
    container.backgroundColor = UIColor.whiteColor;
    container.layer.cornerRadius = 8;
    container.layer.shadowColor = UIColor.blackColor.CGColor;
    container.layer.shadowOffset = CGSizeZero;
    container.layer.shadowRadius = 15;
    container.layer.shadowOpacity = 0.33;
    container.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1);
    container.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:55];
    UIImage *successImage = [UIImage systemImageNamed:@"checkmark.circle" withConfiguration:configuration];

    UIImageView *success = [[UIImageView alloc] init];
    success.contentMode = UIViewContentModeCenter;
    success.image = successImage;
    success.tintColor = [UIColor colorWithRed:0.0 green:0.47 blue:0.0 alpha:1.0];
    success.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:container];
    [container addSubview:success];

    [NSLayoutConstraint activateConstraints:@[
        [container.heightAnchor constraintGreaterThanOrEqualToConstant:80.0f],
        [container.widthAnchor constraintEqualToConstant:80.0f],
        [container.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [container.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:60],

        [success.widthAnchor constraintEqualToConstant:75.0f],
        [success.heightAnchor constraintEqualToConstant:75.0f],
        [success.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [success.centerXAnchor constraintEqualToAnchor:container.centerXAnchor]
       ]
     ];

    self.successView = container;
    [self animateInSuccess:callback];
}

- (void)animateInSuccess:(void (^)(BOOL finished))callback {
    self.successView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.successView.transform = CGAffineTransformIdentity;
        self.successView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self animateOutSuccess:callback];
    }];
}

- (void)animateOutSuccess:(void (^)(BOOL finished))callback {
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.successView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        self.successView.alpha = 0;
    } completion:^(BOOL finished) {
        callback(finished);
    }];
}

@end
