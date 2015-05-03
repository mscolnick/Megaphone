//
//  CommentTableView.h
//  Megaphone
//
//  Created by Myles Scolnick on 5/1/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CommentTableView : UITableView

@property (strong, nonatomic) NSArray *comments;

@end
