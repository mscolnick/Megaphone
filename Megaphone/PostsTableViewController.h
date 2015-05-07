//
//  PostsTableViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/8/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PostsTableViewController : PFQueryTableViewController

@property PFObject *companyObj;
- (IBAction)segmentSwitch:(id)sender;

@end
