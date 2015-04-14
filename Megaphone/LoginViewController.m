//
//  LoginViewController.m
//  Megaphone
//
//  Created by Hriday Kemburu on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)facebookLogin:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"public_profile"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in with facebook!");
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;
                        NSString *facebookID = userData[@"id"];
                        NSString *name = userData[@"name"];
                        NSString *first_name = userData[@"first_name"];
                        NSString *last_name = userData[@"last_name"];
                        
                        NSString *picURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                        
                        PFUser *currentUser = [PFUser currentUser];
                        currentUser[@"name"] = name;
                        currentUser[@"id"] = facebookID;
                        currentUser[@"imageLink"] = picURL;
                        currentUser[@"first_name"] = first_name;
                        currentUser[@"last_name"] = last_name;
                        [currentUser saveInBackground];
                    }
                }];
                
            } else {
                NSLog(@"User logged in with facebook!");
            }

            UITabBarController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBarControllerID"];
            //obj.selectedIndex = 1;
            [self presentModalViewController:obj animated:YES];
        }
    }];

}
@end
