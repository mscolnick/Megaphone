//
//  AppDelegate.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/5/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>
#import "MLoginViewController.h"
#import "CompaniesViewController.h"
#import "PostsTableViewController.h"
#import "MegaphoneUtility.h"
#import "PostViewController.h"

@interface AppDelegate () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"Vr9N0uG67wnATYRFpxJZsGTsBsGiLr7HofeQ0lAW"
                  clientKey:@"zVeZXoZQSbnRQNLaHj8H7Zan49lLcOflViOpRIhY"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    // Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
    [PFFacebookUtils initializeFacebook];
    
    [self login];
    
    //System Wide configs
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Copperplate" size:18.0f]}];
    [[UINavigationBar appearance] setTintColor:[UIColor secondaryColor]]; // this will change the back button tint
    [[UINavigationBar appearance] setBarTintColor:[UIColor mainColor]]; // #007ee5
        


    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    
    if([[url host] isEqualToString:@"company"]){
        [tabController setSelectedIndex:0];
        UINavigationController *nav = (UINavigationController*) tabController.selectedViewController;
        PFObject *companyObj = [MegaphoneUtility getCompanyObject:[url path]];
        if(companyObj){
            PostsTableViewController *postTableVC= [storyboard instantiateViewControllerWithIdentifier:@"postTableViewController"];
            postTableVC.companyObj = companyObj;
            [nav pushViewController:postTableVC animated:YES];
        }
        return YES;
    } else if([[url host] isEqualToString:@"post"]){
        [tabController setSelectedIndex:0];
        UINavigationController *nav = (UINavigationController*) tabController.selectedViewController;
        PFObject *postObj = [MegaphoneUtility getPostObject:[url path]];
        if(postObj){
            PFObject *companyObj = [MegaphoneUtility getCompanyObject:postObj[kPostsCompanyIdKey]];
            PostsTableViewController *postTableVC= [storyboard instantiateViewControllerWithIdentifier:@"postTableViewController"];
            postTableVC.companyObj = companyObj;
            [nav pushViewController:postTableVC animated:YES];
            PostViewController *postVC = [storyboard instantiateViewControllerWithIdentifier:@"postViewController"];
            postVC.postObj = postObj;
            [nav pushViewController:postVC animated:YES];
        }
        return YES;
    } else {
        if([[url host] isEqualToString:@"profile"]){
            [tabController setSelectedIndex:1];
            return YES;
        }
    }
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

#pragma mark - PFLoginDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    if (user.isNew) {
        NSLog(@"User signed up and logged in with facebook!");
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler: ^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                NSString *first_name = userData[kPostsFirstNameKey];
                NSString *last_name = userData[kPostsLastNameKey];
                
                NSString *picURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                
                PFUser *currentUser = [PFUser currentUser];
                currentUser[@"name"] = name;
                currentUser[@"id"] = facebookID;
                currentUser[@"imageLink"] = picURL;
                currentUser[kPostsFirstNameKey] = first_name;
                currentUser[kPostsLastNameKey] = last_name;
                [currentUser saveInBackground];
            }
        }];
    }
    NSLog(@"Main view controller");

    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

- (void)login{
    
    if ([PFUser currentUser]) {
        NSLog(@"Logged in");
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
//        NSLog([[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController]);
    } else {
        NSLog(@"Not logged in");
        
        // Create the log in view controller
        MLoginViewController *logInViewController = [[MLoginViewController alloc] init];
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        [logInViewController setFacebookPermissions:@[@"public_profile"]];
        [logInViewController setFields: PFLogInFieldsTwitter | PFLogInFieldsFacebook];

        [logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:nil]];
        //[logInViewController.logInView setBackgroundColor:[UIColor mainColor]];
                
        self.window.rootViewController = logInViewController;
    }
}

@end
