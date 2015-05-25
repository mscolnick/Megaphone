//
//  ProfileTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfilePostsTableViewController.h"
#import "ProfileImageView.h"

@interface ProfileTableViewController ()
@property (strong, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *profileBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *user = [PFUser currentUser];
    [_profileImageView setImageWithLink: user[@"imageLink"]];
    _nameLabel.text = user[@"name"];
    self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"Me";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMyPosts"]) {
        ProfilePostsTableViewController *postVC = [segue destinationViewController];
        postVC.tableType = MyPostsTable;
    }
    else if ([segue.identifier isEqualToString:@"toFollowing"]) {
        ProfilePostsTableViewController *postVC = [segue destinationViewController];
        postVC.tableType = FollowingTable;
    }
    else if ([segue.identifier isEqualToString:@"toMyComments"]) {
        ProfilePostsTableViewController *postVC = [segue destinationViewController];
        postVC.tableType = MyCommentsTable;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.tableView.frame.size.height -
            _profileBackgroundView.frame.size.height -
            self.navigationController.navigationBar.frame.size.height -
            self.tabBarController.tabBar.frame.size.height -
            [UIApplication sharedApplication].statusBarFrame.size.height)/3;
}


- (IBAction)noiseLevelButton:(id)sender {
    
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:0.3f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    [_scoreLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    
    if (_scoreLabel.text.length == 0){
        _scoreLabel.text = [NSString stringWithFormat:@"Noise Level %@", [[PFUser currentUser][@"karma"] stringValue]];
    }else{
        _scoreLabel.text = @"";
    }

}

@end
