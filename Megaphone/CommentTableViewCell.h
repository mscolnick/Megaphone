//
//  CommentTableViewCell.h
//  Megaphone
//
//  Created by Hriday Kemburu on 5/1/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonOutlet;
- (IBAction)like:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabelOutlet;
@property (strong, nonatomic) PFObject *commentObj;

@end
