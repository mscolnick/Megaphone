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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *post = [_myPosts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = post[@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"viewPost"]) {
        //sets correct post for the detail post to load
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
