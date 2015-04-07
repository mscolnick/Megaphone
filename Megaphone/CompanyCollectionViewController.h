//
//  CompanyCollectionViewController.h
//  Megaphone
//
//  Created by Hriday Kemburu on 4/6/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyCell.h"

@interface CompanyCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *companyImageOutlet;
@property (strong, nonatomic) NSMutableArray *companyPhotos;

@end
