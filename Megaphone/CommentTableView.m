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
    
    [cell.profileImageView setImageWithLink:comment[@"user"][@"imageLink"]];
    
    cell.nameLabel.text = comment[@"name"];
    cell.commentLabel.text = comment[@"comment"];
    cell.timeLabel.text = comment[@"timeStamp"];
    
    return cell;
}



@end
