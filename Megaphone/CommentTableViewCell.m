//
//  CommentTableViewCell.m
//  Megaphone
//
//  Created by Hriday Kemburu on 5/1/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "MegaphoneUtility.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)like:(id)sender {
    [MegaphoneUtility containsUserInBackground:_commentObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnliked];
        } else {
            [self changeToLiked];
        }
    }];
}

- (void)changeToLiked {
    [_likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    [MegaphoneUtility likeCommentInBackground:_commentObj block:^(BOOL succeeded, NSError *error) {
        _numLikesLabelOutlet.text = [_commentObj[@"numLikes"] stringValue];
    }];
}

- (void)changeToUnliked {
    [_likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
    [MegaphoneUtility unlikeCommentInBackground:_commentObj block:^(BOOL succeeded, NSError *error) {
        _numLikesLabelOutlet.text = [_commentObj[@"numLikes"] stringValue];
    }];
}

@end
