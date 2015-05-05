//
//  MyUpvoteCell.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostCell.h"

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
    NSLog(@"up button");
    
    [self containsUser:_postObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnliked];
        } else {
            [self changeToLiked];
        }
    }];
}

- (void)changeToLiked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}

- (void)changeToUnliked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation removeObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save];
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}

- (void)containsUser:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock {
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock: ^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

@end
