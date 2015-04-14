//
//  CompanyCollectionViewController.m
//  Megaphone
//
//  Created by Hriday Kemburu on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "CompanyCollectionViewController.h"
#import "PostsTableViewController.h"

@interface CompanyCollectionViewController () {
    PFObject *companyObject;
}

@end

@implementation CompanyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Register cell classes
    [self.collectionView registerClass:[CompanyCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    _myCompanies = [[NSMutableArray alloc] init];
    [self getCompanies];
}

-(void)getCompanies
{
    PFQuery *query = [PFQuery queryWithClassName:@"Company"];
    [query orderByDescending:@"createdAt"];
    query.limit = 30;
    _myCompanies = [query findObjects];
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    imgView.clipsToBounds = YES;
    
    PFObject *post = [_myCompanies objectAtIndex:indexPath.row];
    [post fetchIfNeeded]; //maybe take out
    PFFile *imageFile = post[@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
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
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:@"companyToPosts"]) {
         //sets correct post for the detail post to load
         PostsTableViewController *postVC = [segue destinationViewController];
         postVC.companyObj = companyObject;
         
     }
}
 


@end
