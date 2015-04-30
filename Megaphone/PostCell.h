//
//  MyUpvoteCell.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (strong, nonatomic) PFObject *postObj;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

- (void)changeToLiked;
- (void)changeToDisliked;

@end
