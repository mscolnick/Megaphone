//
//  MyUpvoteCell.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostCell.h"
#import "MegaphoneUtility.h"

#define MIN_LIKES -3

@implementation PostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)upButtonPressed:(id)sender {    
    [MegaphoneUtility containsUserInBackground:_postObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnliked];
        } else {
            [self changeToLiked];
        }
    }];
}

- (void)changeToLiked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    [MegaphoneUtility likePostInBackground:_postObj block:^(BOOL succeeded, NSError *error) {
        _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
    }];
}

- (void)changeToUnliked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
    [MegaphoneUtility unlikePostInBackground:_postObj block:^(BOOL succeeded, NSError *error) {
        _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
    }];
}

@end
