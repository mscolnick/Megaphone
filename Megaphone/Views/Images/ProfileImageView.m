//
//  ProfileImageView.m
//  Megaphone
//
//  Created by Myles Scolnick on 5/7/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "ProfileImageView.h"

@implementation ProfileImageView

- (void)setImage:(UIImage *)image{
    [super setImage:image];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0;
    [self.layer setBorderColor: [[UIColor lightColor] CGColor]];
    [self.layer setBorderWidth: 1.5];
    self.backgroundColor = [UIColor lightColor];
    [self setNeedsLayout];
}

- (void)setImageWithLink: (NSString *)string{
    UIImage *profileImage;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
    if (imageData) {
        profileImage = [UIImage imageWithData:imageData];
    } else {
        profileImage = [UIImage imageNamed:@"defaultUser"];
    }
    [self setImage:profileImage];
}

@end
