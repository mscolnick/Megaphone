//
//  MLoginViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 5/7/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "MLoginViewController.h"

@interface MLoginViewController ()

@end

@implementation MLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MegaphoneWhite"]]];
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blur3"]]];
}

@end
