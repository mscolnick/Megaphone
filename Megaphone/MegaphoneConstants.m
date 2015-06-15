//
//  MegaphoneConstants.m
//  Megaphone
//
//  Created by Myles Scolnick on 6/8/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "MegaphoneConstants.h"

#pragma mark - Launch URLs

#pragma mark - NSNotification

#pragma mark - User Info Keys
NSString *const kUserLikedPhoto                            = @"liked";
NSString *const kUserCommentKey                            = @"comment";
NSString *const kObjectIdKey                               = @"objectId";
NSString *const kUsernameKey                               = @"username";
NSString *const kUsernameIdKey                             = @"usernameId";

#pragma mark - Relation Keys
NSString *const kRelationFollowers                         = @"followers";
NSString *const kRelationLikers                            = @"likers";
NSString *const kRelationCommenters                        = @"commenters";
NSString *const kRelationReporters                         = @"reporters";


#pragma mark - Installation Class

// Field keys
NSString *const kUserKey                                   = @"user";
NSString *const kCreatedAtKey                              = @"createdAt";


#pragma mark - Posts Class
// Class key
NSString *const kPostsClassKey                             = @"Posts";

// Field keys
NSString *const kPostsTitleKey                             = @"title";
NSString *const kPostsCompanyKey                           = @"company";
NSString *const kPostsDescriptionKey                       = @"description";
NSString *const kPostsTypeKey                              = @"type";
NSString *const kPostsFirstNameKey                         = @"first_name";
NSString *const kPostsLastNameKey                          = @"last_name";
NSString *const kPostsNumLikesKey                          = @"numLikes";
NSString *const kPostsNumReportsKey                        = @"numReports";
NSString *const kPostsNumFollowersKey                      = @"numFollowers";
NSString *const kPostsNumCommentsKey                       = @"numComments";
NSString *const kPostsReportedKey                          = @"reported";
NSString *const kPostsCompanyIdKey                         = @"companyId";

#pragma mark - User Class
// Field keys
NSString *const kUserDisplayNameKey                        = @"displayName";
NSString *const kUserFacebookIDKey                         = @"facebookId";
NSString *const kUserPhotoIDKey                            = @"photoId";
NSString *const kUserProfilePicSmallKey                    = @"profilePictureSmall";
NSString *const kUserProfilePicMediumKey                   = @"profilePictureMedium";
NSString *const kUserFacebookFriendsKey                    = @"facebookFriends";
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kUserEmailKey                              = @"email";
NSString *const kUserAutoFollowKey                         = @"autoFollow";

#pragma mark - Comments Class
// Class key
NSString *const kCommentsClassKey                          = @"Comments";

// Field keys
NSString *const kCommentsCommentKey                        = @"comment";
NSString *const kCommentsCompanyKey                        = @"company";
NSString *const kCommentsNumLikesKey                       = @"numLikes";
NSString *const kCommentsNumReportsKey                     = @"numReports";
NSString *const kCommentsReportedKey                       = @"reported";
NSString *const kCommentsTimeStampKey                      = @"timeStamp";

//Pointers
NSString *const kCommentsPostKey                           = @"post";

#pragma mark - Company Class
// Class key
NSString *const kCompanyClassKey                           = @"Company";

// Field keys
NSString *const kCompanyImageKey                           = @"image";
NSString *const kCompanyNameKey                            = @"name";
NSString *const kCompanyNumPostsKey                        = @"numPosts";
NSString *const kCompanyPostsKey                           = @"posts";
NSString *const kCompanyRankKey                            = @"rank";


#pragma mark - Cached Posts Attributes
// keys
NSString *const kCacheIsLikedByCurrentUserKey              = @"isLikedByCurrentUser";
NSString *const kCacheLikeCountKey                         = @"likeCount";
NSString *const kCacheLikersKey                            = @"likers";
NSString *const kCacheCommentCountKey                      = @"numComments";
NSString *const kCacheCommentersKey                        = @"commenters";


#pragma mark - Cached User Attributes


#pragma mark - Push Notification Payload Keys

NSString *const kNotificationAlertKey                      = @"alert";
NSString *const kNotificationBadgeKey                      = @"badge";
NSString *const kNotificationSoundKey                      = @"sound";

NSString *const kPushPayloadPayloadTypeKey                 = @"p";
NSString *const kPushPayloadPayloadTypeActivityKey         = @"a";

NSString *const kPushPayloadActivityTypeKey                = @"t";
NSString *const kPushPayloadActivityLikeKey                = @"l";
NSString *const kPushPayloadActivityCommentKey             = @"c";
NSString *const kPushPayloadActivityFollowKey              = @"f";

NSString *const kPushPayloadFromUserObjectIdKey            = @"fu";
NSString *const kPushPayloadToUserObjectIdKey              = @"tu";
NSString *const kPushPayloadPostObjectIdKey                = @"pid";




#pragma mark - Colors

@implementation UIColor (ProjectName)

+(UIColor *) mainColor { return [UIColor colorWithRed:52.0/255.0 green: 73.0/255.0 blue: 94.0/255.0 alpha: 1.0]; }
+(UIColor *) secondaryColor { return [UIColor colorWithRed:183.0/255.0 green: 228.0/255.0 blue: 242.0/255.0 alpha: 1.0]; }
+(UIColor *) darkColor { return [UIColor colorWithRed:45.0/255.0 green: 62.0/255.0 blue: 79.0/255.0 alpha: 1.0]; }
+(UIColor *) lightColor { return [UIColor colorWithRed:236.0/255.0 green: 240.0/255.0 blue: 241.0/255.0 alpha: 1.0]; }

@end