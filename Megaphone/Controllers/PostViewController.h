//
//  PostViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostViewController
    : UIViewController<UIActionSheetDelegate, UITableViewDelegate,
                       UITableViewDataSource, UITextFieldDelegate,
                       UIAlertViewDelegate>

@property PFObject *postObj;

@end
