//
//  CompaniesViewController.m
//  Megaphone
//
//  Created by Hriday Kemburu on 5/4/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "CompaniesViewController.h"
#import "PostsTableViewController.h"

#define searchScopes(int) [@[@"title", @"company"] objectAtIndex: int]

@interface CompaniesViewController (){
    PFObject *companyObject;
    int selectedSegment;
}

@end

@implementation CompaniesViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Register cell classes
    [self.collectionView registerClass:[CompanyCell class] forCellWithReuseIdentifier:reuseIdentifier];
    selectedSegment = 0;
    
    // Do any additional setup after loading the view.
    _myCompanies = [[NSMutableArray alloc] init];
    
    [self getCompanies];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getCompanies {
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    if (selectedSegment == 0) {
        [query orderByDescending:@"numPosts"];
    } else if (selectedSegment == 1) {
        [query orderByAscending:@"name"];
    }
    query.limit = 30;
    _myCompanies = [NSMutableArray arrayWithArray:[query findObjects]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_myCompanies count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CompanyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imgView.clipsToBounds = YES;
    
    PFObject *post = [_myCompanies objectAtIndex:indexPath.row];
    [post fetchIfNeeded]; //maybe take out
    PFFile *imageFile = post[@"image"];
    [imageFile getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
        if (!error) {
            imgView.image = [UIImage imageWithData:imageData];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    
    [cell addSubview:imgView];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    companyObject = [_myCompanies objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"companyToPosts" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"companyToPosts"]) {
        PostsTableViewController *postVC = [segue destinationViewController];
        postVC.companyObj = companyObject;
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    selectedSegment = (int) segmentedControl.selectedSegmentIndex;
    [self getCompanies];
    [self.collectionView reloadData];
}

@end
