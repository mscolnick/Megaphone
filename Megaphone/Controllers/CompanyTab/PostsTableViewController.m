//
//  PostsTableViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/8/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "PostsTableViewController.h"
#import "NewPostViewController.h"
#import "PostViewController.h"
#import "PostCell.h"
#import "GTScrollNavigationBar.h"
#import "MegaphoneUtility.h"

#define tableTitles(enum) \
  [@[ @"My Posts", @"Following", @"My Comments" ] objectAtIndex:enum]
#define searchScopes(int) \
  [@[ @"all", @"feature", @"bug", @"idea", @"other" ] objectAtIndex:int]

@interface PostsTableViewController ()<UISearchBarDelegate,
                                       UISearchResultsUpdating> {
  int selectedSegment;
}

@property(strong, nonatomic) UISearchController *searchController;

typedef NS_ENUM(NSInteger, PostsSearchScope) {
  searchScopeAll = 0,
  searchScopeBug = 1,
  searchScopeFeature = 2,
  searchScopeOther = 3,
};

@end

@implementation PostsTableViewController

static NSString *const reuseIdentifier = @"Cell";

- (instancetype)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
  }
  return self;
}

- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:kPostsClassKey];

  NSString *companyName = _companyObj[@"name"];
  [query includeKey:kUserKey];
  [query whereKey:@"company" equalTo:companyName];
  if (selectedSegment == 0) {
    [query orderByDescending:kCreatedAtKey];
  } else if (selectedSegment == 1) {
    [query orderByDescending:@"numLikes"];
  }

  NSString *searchString = self.searchController.searchBar.text;
  if (searchString.length > 0) {
    NSString *xx = [NSString stringWithFormat:@"%@", searchString];
    [query whereKey:kPostsTitleKey matchesRegex:xx modifiers:@"i"];
  }
  long scopeType = self.searchController.searchBar.selectedScopeButtonIndex;
  if (scopeType != 0) {
    [query whereKey:kPostsTypeKey equalTo:searchScopes(scopeType)];
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

  self.navigationController.navigationBar.topItem.title = @"";

  selectedSegment = 0;

  self.searchController =
      [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;

  self.searchController.searchBar.scopeButtonTitles =
      @[ @"All", @"Feature", @"Bug", @"Idea", @"Other" ];
  self.searchController.searchBar.delegate = self;

  self.tableView.tableHeaderView = self.searchController.searchBar;
  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self hideSearchBar];
  self.tabBarController.tabBar.hidden = NO;
  self.navigationController.scrollNavigationBar.scrollView = self.tableView;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  [self.navigationController.scrollNavigationBar
      resetToDefaultPositionWithAnimation:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
  PostCell *cell =
      [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:reuseIdentifier];
  }

  cell.textLabel.text = object[kPostsTitleKey];
  cell.numLikesLabel.text = [object[@"numLikes"] stringValue];
  cell.numCommentsLabel.text = [object[@"numComments"] stringValue];
  cell.postObj = object;

  // Check if user likes the post
  BOOL contains =
      [MegaphoneUtility containsUser:object relationType:kRelationLikers];
  if (contains) {
    [cell.upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"]
                   forState:UIControlStateNormal];
  } else {
    [cell.upButton setImage:[UIImage imageNamed:@"ios7-arrow-up"]
                   forState:UIControlStateNormal];
  }

  return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  return _companyObj[@"name"];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  UIView *view = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
  UILabel *label = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 20)];
  label.textAlignment = NSTextAlignmentCenter;
  [label setFont:[UIFont boldSystemFontOfSize:20]];
  NSString *string = _companyObj[@"name"];

  [label setText:string];
  [view addSubview:label];
  [view setBackgroundColor:[UIColor lightColor]];
  return view;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"viewPost"]) {
    PostViewController *postVC = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    PFObject *postObject = (self.objects)[path.row];
    postVC.postObj = postObject;
  } else if ([segue.identifier isEqualToString:@"createPost"]) {
    NewPostViewController *postVC = [segue destinationViewController];
    postVC.companyObj = _companyObj;
  }
}

- (IBAction)segmentSwitch:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  selectedSegment = (int)segmentedControl.selectedSegmentIndex;
  [self loadObjects];
}

#pragma mark - UISearchResultsUpdating

- (void)searchBar:(UISearchBar *)searchBar
    selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
  [self loadObjects];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  self.navigationController.scrollNavigationBar.scrollView = self.tableView;
}

- (void)hideSearchBar {
  CGRect newBounds = self.tableView.bounds;
  if (self.tableView.bounds.origin.y < 44) {
    newBounds.origin.y =
        newBounds.origin.y + self.searchController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
  }
}

@end
