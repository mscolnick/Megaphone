//
//  CompanyCell.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/5/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "CompanyCell.h"

@implementation CompanyCell

- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        _imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView.layer setCornerRadius:5.f];
        // border
        [_imageView.layer setBorderColor:[UIColor lightColor].CGColor];
        [_imageView.layer setBorderWidth:1.f];
        self.backgroundColor = [UIColor lightColor];
        [self.layer setCornerRadius:5.f];
        
        // shadow
        [self.layer setShadowColor:[UIColor darkColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        [self addSubview:_imageView];
    }
    return self;
}

@end
