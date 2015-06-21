//
//  CompaniesViewController.m
//  Megaphone
//
//  Created by Hriday Kemburu on 5/4/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "CompaniesViewController.h"
#import "PostsTableViewController.h"

@interface CompaniesViewController () {
  PFObject *companyObject;
  int selectedSegment;
}
@property(weak, nonatomic) IBOutlet UISearchBar *companySearchBar;

@end

@implementation CompaniesViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
  [super viewDidLoad];

  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  // Register cell classes
  [self.collectionView registerClass:[CompanyCell class]
          forCellWithReuseIdentifier:reuseIdentifier];
  selectedSegment = 0;

  // Do any additional setup after loading the view.
  _myCompanies = [[NSMutableArray alloc] init];

  [self getCompanies];
  [self customizeCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tabBarController.tabBar.hidden = NO;
}

- (void)getCompanies {
  PFQuery *query = [PFQuery queryWithClassName:kCompanyClassKey];
  if (selectedSegment == 0) {
    [query orderByDescending:kCompanyNumPostsKey];
  } else if (selectedSegment == 1) {
    [query orderByAscending:@"name"];
  }
  query.limit = 30;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    _myCompanies = [NSMutableArray arrayWithArray:objects];
    [self.collectionView reloadData];
  }];
}

- (void)getCompaniesWithText:(NSString *)text {
  PFQuery *query = [PFQuery queryWithClassName:kCompanyClassKey];
  if (selectedSegment == 0) {
    [query orderByDescending:kCompanyNumPostsKey];
  } else if (selectedSegment == 1) {
    [query orderByAscending:@"name"];
  }

  NSString *xx = [NSString stringWithFormat:@"%@", text];
  [query whereKey:@"name" matchesRegex:xx modifiers:@"i"];

  query.limit = 30;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    _myCompanies = [NSMutableArray arrayWithArray:objects];
    [self.collectionView reloadData];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_myCompanies count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CompanyCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  PFObject *company = _myCompanies[indexPath.row];
  //    cell.imageView.image = [UIImage imageNamed:@"ios7-briefcase"]; //
  //    placeholder image
  [company
      fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.imageView.file = (PFFile *)company[@"image"];  // remote image
        [cell.imageView loadInBackground];
      }];

  return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted
 during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView
 shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView
 shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for
 the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView
 shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }

 - (BOOL)collectionView:(UICollectionView *)collectionView
 canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
 withSender:(id)sender {
 return NO;
 }

 - (void)collectionView:(UICollectionView *)collectionView
 performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
 withSender:(id)sender {

 }
 */

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  companyObject = _myCompanies[indexPath.row];
  [self performSegueWithIdentifier:@"companyToPosts" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"companyToPosts"]) {
    PostsTableViewController *postVC = [segue destinationViewController];
    postVC.companyObj = companyObject;
  }
}

- (IBAction)segmentSwitch:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  selectedSegment = (int)segmentedControl.selectedSegmentIndex;
  if (self.companySearchBar.text.length > 0) {
    [self getCompaniesWithText:self.companySearchBar.text];
  } else {
    [self getCompanies];
  }
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  if (searchText.length > 0) {
    [self getCompaniesWithText:searchText];
  } else {
    [self getCompanies];
  }
}

- (void)customizeCollectionView {
  self.collectionView.backgroundColor =
      [UIColor colorWithWhite:0.25f alpha:1.0f];
  UICollectionViewFlowLayout *flow =
      (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  flow.sectionInset = UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f);
  flow.itemSize = CGSizeMake(100, 100);
}

@end
