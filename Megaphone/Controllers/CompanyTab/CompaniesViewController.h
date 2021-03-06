//
//  CompaniesViewController.h
//  Megaphone
//
//  Created by Hriday Kemburu on 5/4/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyCell.h"
#import <Parse/Parse.h>
#import "MegaphoneConstants.h"

@interface CompaniesViewController
    : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
                       UISearchBarDelegate>

@property(strong, nonatomic) NSMutableArray *myCompanies;

@property(weak, nonatomic) IBOutlet UISegmentedControl *segControlOutlet;
- (IBAction)segmentSwitch:(id)sender;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
