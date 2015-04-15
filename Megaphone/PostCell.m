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
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}


- (IBAction)downButtonPressed:(id)sender {
    NSLog(@"down button");
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _numLikesLabel.text = [_postObj[@"numLikes"] stringValue];
}

@end
