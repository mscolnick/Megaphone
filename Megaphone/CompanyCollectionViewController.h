//
//  CompanyCollectionViewController.h
//  Megaphone
//
//  Created by Hriday Kemburu on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyCell.h"
#import <Parse/Parse.h>

@interface CompanyCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *myCompanies;

@end
