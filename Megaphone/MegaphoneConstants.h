//
//  MegaphoneConstants.h
//  Megaphone
//
//  Created by Myles Scolnick on 6/8/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(unsigned int, TabBarControllerViewControllerIndex) {
    CompanyTabBarItemIndex = 0,
    ProfileTabBarItemIndex = 1,
    MoreTabBarItemIndex = 2
};

#pragma mark - Launch URLs

#pragma mark - NSNotification

#pragma mark - User Info Keys
extern NSString *const kUserLikedPhoto;
extern NSString *const kUserCommentKey;
extern NSString *const kObjectIdKey;
extern NSString *const kUsernameKey;
extern NSString *const kUsernameIdKey;

#pragma mark - Relation Keys
extern NSString *const kRelationFollowers;
extern NSString *const kRelationLikers;
extern NSString *const kRelationCommenters;
extern NSString *const kRelationReporters;


#pragma mark - Installation Class

// Field keys
extern NSString *const kUserKey;
extern NSString *const kCreatedAtKey;


#pragma mark - Posts Class
// Class key
extern NSString *const kPostsClassKey;

// Field keys
extern NSString *const kPostsTitleKey;
extern NSString *const kPostsCompanyKey;
extern NSString *const kPostsDescriptionKey;
extern NSString *const kPostsTypeKey;
extern NSString *const kPostsFirstNameKey;
extern NSString *const kPostsLastNameKey;
extern NSString *const kPostsNumLikesKey;
extern NSString *const kPostsNumReportsKey;
extern NSString *const kPostsNumFollowersKey;
extern NSString *const kPostsNumCommentsKey;
extern NSString *const kPostsReportedKey;
extern NSString *const kPostsCompanyIdKey;

#pragma mark - User Class
// Field keys
extern NSString *const kUserDisplayNameKey;
extern NSString *const kUserFacebookIDKey;
extern NSString *const kUserPhotoIDKey;
extern NSString *const kUserProfilePicSmallKey;
extern NSString *const kUserProfilePicMediumKey;
extern NSString *const kUserFacebookFriendsKey;
extern NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kUserEmailKey;
extern NSString *const kUserAutoFollowKey;

#pragma mark - Comments Class
// Class key
extern NSString *const kCommentsClassKey;

// Field keys
extern NSString *const kCommentsCommentKey;
extern NSString *const kCommentsCompanyKey;
extern NSString *const kCommentsNumLikesKey;
extern NSString *const kCommentsNumReportsKey;
extern NSString *const kCommentsReportedKey;
extern NSString *const kCommentsTimeStampKey;

//Pointers
extern NSString *const kCommentsPostKey;

#pragma mark - Company Class
// Class key
extern NSString *const kCompanyClassKey;

// Field keys
extern NSString *const kCompanyImageKey;
extern NSString *const kCompanyNameKey;
extern NSString *const kCompanyNumPostsKey;
extern NSString *const kCompanyPostsKey;
extern NSString *const kCompanyRankKey;


#pragma mark - Cached Posts Attributes
// keys
extern NSString *const kCacheIsLikedByCurrentUserKey;
extern NSString *const kCacheLikeCountKey;
extern NSString *const kCacheLikersKey;
extern NSString *const kCacheCommentCountKey;
extern NSString *const kCacheCommentersKey;


#pragma mark - Cached User Attributes


#pragma mark - Push Notification Payload Keys

extern NSString *const kNotificationAlertKey;
extern NSString *const kNotificationBadgeKey;
extern NSString *const kNotificationSoundKey;

extern NSString *const kPushPayloadPayloadTypeKey;
extern NSString *const kPushPayloadPayloadTypeActivityKey;

extern NSString *const kPushPayloadActivityTypeKey;
extern NSString *const kPushPayloadActivityLikeKey;
extern NSString *const kPushPayloadActivityCommentKey;
extern NSString *const kPushPayloadActivityFollowKey;

extern NSString *const kPushPayloadFromUserObjectIdKey;
extern NSString *const kPushPayloadToUserObjectIdKey;
extern NSString *const kPushPayloadPostObjectIdKey;


#pragma mark - Colors

@interface UIColor (Megaphone)

+(UIColor *) mainColor;
+(UIColor *) secondaryColor;
+(UIColor *) darkColor;
+(UIColor *) lightColor;

@end
