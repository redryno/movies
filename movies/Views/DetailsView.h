//
//  DetailsView.h
//  movies
//
//  Created by Ryan Bigger on 10/9/19.
//  Copyright © 2019 Ryan Bigger. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsView : UIView

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UILabel *detailTextLabel;
@property (nonatomic) UIView *successView;
- (void)showSuccess:(void (^)(BOOL finished))callback;

@end

NS_ASSUME_NONNULL_END
