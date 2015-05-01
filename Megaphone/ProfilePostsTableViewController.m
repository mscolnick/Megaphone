//
//  MyPostsTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "ProfilePostsTableViewController.h"
#import "PostViewController.h"

#define searchScopes(int) [@[@"title", @"company"] objectAtIndex: int]

@interface ProfilePostsTableViewController () <UISearchBarDelegate, UISearchResultsUpdating> {
    PFObject *postObject;
    int selectedSegment;
}

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ProfilePostsTableViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.prompt = tableTitles(_tableType);
    self.navigationController.navigationBar.topItem.title = @"";

    _myPosts = [[NSMutableArray alloc] init];
    selectedSegment = 0;
    //[self getPosts];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[@"Title", @"Company"];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    [self getPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    if (selectedSegment == 0) {
        [query orderByDescending:@"createdAt"];
    } else if (selectedSegment == 1) {
        [query orderByDescending:@"numLikes"];
    }
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:tableQuery(_tableType) equalTo:currentUser];
    
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *post = [_myPosts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = post[@"title"];
    cell.detailTextLabel.text = [post[@"company"] uppercaseString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewPost"]) {
        PostViewController *postVC = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        postObject = [_myPosts objectAtIndex:path.row];
        postVC.postObj = postObject;
    }
}

#pragma mark - UISearchResultsUpdating

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    if (selectedSegment == 0) {
        [query orderByDescending:@"createdAt"];
    } else if (selectedSegment == 1) {
        [query orderByDescending:@"numLikes"];
    }
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:tableQuery(_tableType) equalTo:currentUser];
    long scopeType = searchController.searchBar.selectedScopeButtonIndex;
    [query whereKey:searchScopes(scopeType) containsString:searchString];
    
    query.limit = 30;
    _myPosts = [query findObjects];
    [self.tableView reloadData];
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = (int) segmentedControl.selectedSegmentIndex;
    [self getPosts];
    [self.tableView reloadData];
}
@end
