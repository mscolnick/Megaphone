//
//  UIColor+Megaphone.m
//  Megaphone
//
//  Created by Myles Scolnick on 6/21/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "UIColor+Megaphone.h"
#import "HexColor.h"

@implementation UIColor (Megaphone)

#pragma mark - Grey colors

+ (UIColor *)meg_superLightGreyColor
{
    return [UIColor colorWithHexString:@"FAFBFC"];
}

+ (UIColor *)meg_veryLightGreyColor
{
    return [UIColor colorWithHexString:@"E7EBEE"];
}

+ (UIColor *)meg_lightGreyColor
{
    return [UIColor colorWithHexString:@"DEE2E5"];
}

+ (UIColor *)meg_greyColor
{
    return [UIColor colorWithHexString:@"707C7C"];
}

+ (UIColor *)meg_mediumGreyColor
{
    return [UIColor colorWithHexString:@"CACCCE"];
}

+ (UIColor *)meg_darkGreyColor
{
    return [UIColor colorWithHexString:@"262729"];
}

+ (UIColor *)meg_dividerGreyColor
{
    return [UIColor colorWithHexString:@"B7BDBD"];
}

+ (UIColor *)meg_composeGreyBackgroundColor
{
    return [UIColor colorWithHexString:@"F8F9FA"];
}

+ (UIColor *)meg_placeholderTextGreyColor
{
    return [UIColor colorWithHexString:@"C7CBCD"];
}

+ (UIColor *)meg_valleyGrey
{
    return [UIColor colorWithHexString:@"F2F2F2"];
}

+ (UIColor *)meg_horseGrey
{
    return [UIColor colorWithHexString:@"8C8C8C"];
}

+ (UIColor *)meg_extraLightGrey
{
    return [UIColor colorWithHexString:@"F9F9F9"];
}


#pragma mark - Blue colors

+ (UIColor *)meg_megaphoneBlueColor
{
    return [UIColor colorWithHexString:@"3D95CE"];
}

+ (UIColor *)meg_mediumBlueGreyColor
{
    return [UIColor colorWithHexString:@"C0C9CF"];
}

+ (UIColor *)meg_lightBlueColor
{
    return [UIColor colorWithHexString:@"E9F4F9"];
}

+ (UIColor *)meg_buttonBlueColor
{
    return [UIColor colorWithHexString:@"509FD3"];
}

+ (UIColor *)meg_heartBlueColor
{
    return [UIColor colorWithHexString:@"3D94CE"];
}

+ (UIColor *)meg_linkSelectedBlueColor
{
    return [UIColor colorWithHexString:@"355CC2"];
}


#pragma mark - Drawer colors

+ (UIColor *)meg_drawerBackgroundColor
{
    return [UIColor colorWithHexString:@"333B42"];
}

+ (UIColor *)meg_drawerSelectedTextColor
{
    return [UIColor colorWithHexString:@"6EBDF7"];
}

+ (UIColor *)meg_drawerSelectedCellBackgroundColor
{
    return [UIColor colorWithHexString:@"485159"];
}

+ (UIColor *)meg_drawerTextColor
{
    return [UIColor colorWithHexString:@"C0C9CF"];
}

+ (UIColor *)meg_drawerLineColor
{
    return [UIColor colorWithHexString:@"485259"];
}


#pragma mark - Other colors

+ (UIColor *)meg_greenColor
{
    return [UIColor colorWithHexString:@"59BF39"];
}

+ (UIColor *)meg_redColor
{
    return [UIColor colorWithHexString:@"E91A1A"];
}

+ (UIColor *)meg_orangeColor
{
    return [UIColor colorWithHexString:@"FF8000"];
}

@end
