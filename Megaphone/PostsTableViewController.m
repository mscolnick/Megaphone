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

#define tableTitles(enum) [@[@"My Posts", @"Following", @"My Comments"] objectAtIndex: enum]
#define searchScopes(int) [@[@"all", @"feature", @"bug", @"idea",  @"other"] objectAtIndex: int]


@interface PostsTableViewController () <UISearchBarDelegate, UISearchResultsUpdating> {
    PFObject *postObject;
    int selectedSegment;
}

@property (strong, nonatomic) UISearchController *searchController;

typedef NS_ENUM(NSInteger, PostsSearchScope)
{
    searchScopeAll = 0,
    searchScopeBug = 1,
    searchScopeFeature = 2,
    searchScopeOther = 3,
};

@end

@implementation PostsTableViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";

    _myPosts = [[NSMutableArray alloc] init];
    selectedSegment = 0;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    self.searchController.searchBar.scopeButtonTitles = @[@"All", @"Feature", @"Bug", @"Idea", @"Other"];
    self.searchController.searchBar.delegate = self;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self getPosts];
    [self.tableView reloadData];
}

- (void)getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    NSString *companyName = _companyObj[@"name"];
    [query includeKey:@"user"];
    [query whereKey:@"company" equalTo:companyName];
    if (selectedSegment == 0) {
        [query orderByDescending:@"createdAt"];
    } else if (selectedSegment == 1) {
        [query orderByDescending:@"numLikes"];
    }
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
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *post = [_myPosts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = post[@"title"];
    cell.numLikesLabel.text = [post[@"numLikes"] stringValue];
    cell.postObj = post;
    
    //Check if user likes the post
    __block BOOL canSkip = NO;
    [self containsUser:post relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [cell changeToLiked];
            canSkip = YES;
        }
    }];
    if (!canSkip) {
        [self containsUser:post relationType:@"dislikers" block: ^(BOOL contains, NSError *error) {
            if (contains) {
                [cell changeToDisliked];
            }
        }];
    }
    
    return cell;
}


- (void)containsUser:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock {
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock: ^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _companyObj[@"name"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewPost"]) {
        PostViewController *postVC = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        postObject = [_myPosts objectAtIndex:path.row];
        postVC.postObj = postObject;
    }
    if ([segue.identifier isEqualToString:@"createPost"]) {
        NewPostViewController *postVC = [segue destinationViewController];
        postVC.companyObj = _companyObj;
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = (int) segmentedControl.selectedSegmentIndex;
    [self getPosts];
    [self.tableView reloadData];
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
    
    NSString *companyName = _companyObj[@"name"];
    [query whereKey:@"company" equalTo:companyName];
    [query whereKey:@"title" containsString:searchString];
    long scopeType = searchController.searchBar.selectedScopeButtonIndex;
    if(scopeType != 0){
            [query whereKey:@"type" equalTo:searchScopes(scopeType)];
    }
    query.limit = 30;
    _myPosts = [query findObjects];
    [self.tableView reloadData];
}

@end
