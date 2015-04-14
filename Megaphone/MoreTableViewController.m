    //
//  SettingsTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _links = @{
            @"Rate": [NSURL URLWithString: @"https://itunes.com"],
            @"Facebook": [NSURL URLWithString: @"https://facebook.com"],
            @"Twitter": [NSURL URLWithString: @"https://twitter.com"],
            @"Instagram": [NSURL URLWithString: @"https://instagram.com"]
            };
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier];
    
    if(identifier == nil){
        NSLog(@"Error: No identifier");
    }
    else if (_links[identifier]){
        NSLog(@"Valid link");
        [[UIApplication sharedApplication] openURL: _links[identifier]];
    }
    else if([identifier  isEqual: @"Share"]){
        NSLog(@"Sharing");
        NSString *message = @"Checkout Megaphone! Download Here:";
        NSURL *site = [NSURL URLWithString: @"https://www.google.com/search?q=megaphone"];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[message, site] applicationActivities:nil];
        [self presentViewController: activityViewController animated:YES completion:nil];
    }
    else if([identifier  isEqual: @"Logout"]){
        NSLog(@"Logout");
        //TODO: Log out of facebook
    }
    else if([identifier  isEqual: @"Policy"]){
        NSLog(@"Policy");
    }
    else if([identifier  isEqual: @"Terms"]){
        NSLog(@"Terms");
    }
    
    // so cell wont stay highlighted
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}
*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
