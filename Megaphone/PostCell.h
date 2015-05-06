//
//  MyUpvoteCell.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PostCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (strong, nonatomic) PFObject *postObj;
@property (weak, nonatomic) IBOutlet UIButton *upButton;

- (void)changeToLiked;

@end
