//
//  MyPostsTableViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPostsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *myPosts;

@end
