//
//  MyPostsTableViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef enum {
    MyPostsTable,
    FollowingTable,
    MyCommentsTable
} TableType;

#define tableTitles(enum) [@[@"My Posts",@"Following",@"My Comments"] objectAtIndex:enum]


@interface ProfilePostsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *myPosts;
@property TableType tableType;

@end
