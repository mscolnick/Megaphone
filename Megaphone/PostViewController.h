//
//  PostViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property PFObject *postObj;

@end
