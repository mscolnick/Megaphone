//
//  CommentTableView.m
//  Megaphone
//
//  Created by Myles Scolnick on 5/1/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentTableViewCell.h"

@implementation CommentTableView

static NSString *const reuseIdentifier = @"Cell";


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *comment = [_comments objectAtIndex:indexPath.row];
    
    PFUser *author = comment[@"user"];
    
    // Circular Image
    NSURL *profileLink = [NSURL URLWithString:author[@"imageLink"]];
    UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:profileLink]];
    cell.profileImageView.image = profileImage;
    cell.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height / 2;
    cell.profileImageView.layer.masksToBounds = YES;
    cell.profileImageView.layer.borderWidth = 0;
    [cell.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [cell.profileImageView.layer setBorderWidth: 2.0];
    
    cell.nameLabel.text = comment[@"name"];
    cell.commentLabel.text = comment[@"comment"];
    cell.timeLabel.text = comment[@"timeStamp"];
    
    
    return cell;
}



@end
