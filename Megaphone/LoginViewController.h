//
//  LoginViewController.h
//  Megaphone
//
//  Created by Hriday Kemburu on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButtonOutlet;
- (IBAction)facebookLogin:(id)sender;
@end
