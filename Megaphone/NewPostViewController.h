//
//  NewPostViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewPostViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property PFObject *postObj;

@end
