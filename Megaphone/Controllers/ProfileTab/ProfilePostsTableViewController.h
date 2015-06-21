//
//  MyPostsTableViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "MegaphoneConstants.h"

typedef NS_ENUM(unsigned int, TableType) {
    MyPostsTable,
    FollowingTable,
    MyCommentsTable
};

#define tableTitles(enum) [@[@"My Posts", @"Following", @"My Comments"] objectAtIndex: enum]
#define tableQuery(enum) [@[@"user", @"followers", @"commenters"] objectAtIndex: enum]


@interface ProfilePostsTableViewController : PFQueryTableViewController

@property TableType tableType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlOutlet;
- (IBAction)segmentSwitch:(id)sender;

@end
