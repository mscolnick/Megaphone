//
//  NewPostViewController.h
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MegaphoneConstants.h"

@interface NewPostViewController
    : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property(strong, nonatomic) PFObject *companyObj;

@end
