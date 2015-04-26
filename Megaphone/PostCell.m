//
//  MyUpvoteCell.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostCell.h"

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
    [self changeToLiked];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}


- (IBAction)downButtonPressed:(id)sender {
    NSLog(@"down button");
    [self changeToDisliked];
    PFRelation *relation = [_postObj relationForKey:@"dislikers"];
    [relation addObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}

- (void) changeToLiked{
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    NSLog(@"change to liked");
}

- (void) changeToDisliked{
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_downButton setImage:[UIImage imageNamed:@"ios7-arrow-down-red"] forState:UIControlStateNormal];
    NSLog(@"change to disliked");
}

@end
