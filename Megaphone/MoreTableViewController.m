//
//  SettingsTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "MoreTableViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppDelegate.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _links = @{
                   @"Rate": [NSURL URLWithString:@"https://itunes.com"],
                   @"Facebook": [NSURL URLWithString:@"https://facebook.com"],
                   @"Twitter": [NSURL URLWithString:@"https://twitter.com"],
                   @"Instagram": [NSURL URLWithString:@"https://instagram.com"]
                   };
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
    
    if (identifier == nil) {
        NSLog(@"Error: No identifier");
    }
    else if (_links[identifier]) {
        NSLog(@"Valid link");
        [[UIApplication sharedApplication] openURL:_links[identifier]];
    }
    else if ([identifier isEqual:@"Share"]) {
        NSLog(@"Sharing");
        NSString *message = @"Checkout Megaphone! Download Here:";
        NSURL *site = [NSURL URLWithString:@"https://www.google.com/search?q=megaphone"];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[message, site] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else if ([identifier isEqual:@"Logout"]) {
        [self logout];
    }
    else if ([identifier isEqual:@"Policy"]) {
        NSLog(@"Policy");
    }
    else if ([identifier isEqual:@"Terms"]) {
        NSLog(@"Terms");
    }
    
    // so cell wont stay highlighted
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) logout{
    NSLog(@"Logout");
    [[PFFacebookUtils session] closeAndClearTokenInformation];
    [[PFFacebookUtils session] close];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
    [PFUser logOut];
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIViewController* loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginViewControllerID"];
    appDelegateTemp.window.rootViewController = loginController;

}

@end
