//
//  MovieTableViewCell.m
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

static NSString *_identifier = @"MovieTableViewCell";

+ (NSString *)identifier {
    return _identifier;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 8.0f;
        self.detailTextLabel.textColor = UIColor.secondaryLabelColor;
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
}

@end
