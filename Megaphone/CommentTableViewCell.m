//
//  CommentTableViewCell.m
//  Megaphone
//
//  Created by Hriday Kemburu on 5/1/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)like:(id)sender {
    NSLog(@"up button");
    
    [self containsUser:_commentObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnliked];
        } else {
            [self changeToLiked];
        }
    }];
}

- (void)changeToLiked {
    [_likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    PFRelation *relation = [_commentObj relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    
    [_commentObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_commentObj save];
    _numLikesLabelOutlet.text = [_commentObj[@"numLikes"] stringValue];
}

- (void)changeToUnliked {
    [_likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
    PFRelation *relation = [_commentObj relationForKey:@"likers"];
    [relation removeObject:[PFUser currentUser]];
    
    [_commentObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_commentObj save];
    _numLikesLabelOutlet.text = [_commentObj[@"numLikes"] stringValue];
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
