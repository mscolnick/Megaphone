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
    int selectedSegment;
}

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ProfilePostsTableViewController

static NSString *const reuseIdentifier = @"Cell";

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    PFUser *currentUser = [PFUser currentUser];
    [query includeKey:@"user"];
    [query whereKey:tableQuery(_tableType) equalTo:currentUser];
    if (selectedSegment == 0) {
        [query orderByDescending:@"createdAt"];
    } else if (selectedSegment == 1) {
        [query orderByDescending:@"numLikes"];
    }
    
    NSString *searchString = self.searchController.searchBar.text;
    if(searchString.length  > 0){
        NSString *xx = [NSString stringWithFormat:@"^%@", searchString];
        [query whereKey:@"title" matchesRegex:xx modifiers:@"i"];
        
        long scopeType = self.searchController.searchBar.selectedScopeButtonIndex;
        if(scopeType != 0){
            [query whereKey:@"type" equalTo:searchScopes(scopeType)];
        }
    }
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.topItem.title = @"";

    selectedSegment = 0;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[@"Title", @"Company"];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideSearchBar];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = object[@"title"];
    cell.detailTextLabel.text = [object[@"company"] uppercaseString];

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewPost"]) {
        PostViewController *postVC = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PFObject *postObject = [self.objects objectAtIndex:path.row];
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
    [self loadObjects];
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = (int) segmentedControl.selectedSegmentIndex;
    [self loadObjects];
}

- (void) hideSearchBar{
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchController.searchBar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
}
@end
