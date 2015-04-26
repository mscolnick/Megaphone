//
//  ProfileTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfilePostsTableViewController.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    PFUser *user = [PFUser currentUser];
    NSURL *profileLink = [NSURL URLWithString:user[@"imageLink"]];
    NSData *imageData = [NSData dataWithContentsOfURL:profileLink];
    _profileImageView.image = [UIImage imageWithData: imageData];
    _profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    // Circular Image
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height /2;
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.borderWidth = 0;
    
    _nameLabel.text = user[@"name"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toMyPosts"]) {
        ProfilePostsTableViewController *postVC = [segue destinationViewController];
        postVC.tableType = MyPostsTable;
    }
    if([segue.identifier isEqualToString:@"toFollowing"]) {
        ProfilePostsTableViewController *postVC = [segue destinationViewController];
        postVC.tableType = FollowingTable;
    }
}

@end
