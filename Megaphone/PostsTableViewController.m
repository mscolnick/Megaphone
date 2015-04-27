//
//  PostsTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/8/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostsTableViewController.h"
#import "NewPostViewController.h"
#import "PostViewController.h"
#import "PostCell.h"

@interface PostsTableViewController () {
    PFObject *postObject;
}

@end

@implementation PostsTableViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _companyObj[@"name"];
    _myPosts = [[NSMutableArray alloc] init];
    [self getPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPosts]; //BUG: When making a new post, dequeue-ing old cell makes a new post be already voted.
    [self.tableView reloadData];
}

-(void)getPosts
{
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"createdAt"];
    NSString *companyName = _companyObj[@"name"];
    [query whereKey:@"company" equalTo:companyName];
    query.limit = 30;
    _myPosts = [query findObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_myPosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *post = [_myPosts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = post[@"title"];
    cell.numLikesLabel.text = [post[@"numLikes"] stringValue];
    cell.postObj = post;
    
    //Check if user likes the post
    __block BOOL canSkip = NO;
    [self containsUser:post relationType:@"likers" block:^(BOOL contains,NSError* error) {
        if (contains){
            [cell changeToLiked];
            canSkip = YES;
        }
    }];
    if (!canSkip) {
        [self containsUser:post relationType:@"dislikers" block:^(BOOL contains,NSError* error) {
            if (contains){
                [cell changeToDisliked];
            }
        }];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)containsUser:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock
{
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewPost"]) {
        PostViewController *postVC = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        postObject = [_myPosts objectAtIndex:path.row];
        postVC.postObj = postObject;
    }
    if([segue.identifier isEqualToString:@"createPost"]) {
        NewPostViewController *postVC = [segue destinationViewController];
        postVC.companyObj = _companyObj;
    }
}


@end
