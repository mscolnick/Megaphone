//
//  MegaphoneUtility.h
//  Megaphone
//
//  Created by Myles Scolnick on 5/11/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "MegaphoneConstants.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MegaphoneUtility : NSObject

+ (BOOL)containsUser:(PFObject *)myObject relationType:(NSString *)relationType;
+ (void)containsUserInBackground:(PFObject *)myObject
                    relationType:(NSString *)relationType
                           block:(void (^)(BOOL, NSError *))completionBlock;

+ (void)likePost:(PFObject *)post;
+ (void)unlikePost:(PFObject *)post;
+ (void)likePostInBackground:(PFObject *)post
                       block:(void (^)(BOOL succeeded,
                                       NSError *error))completionBlock;
+ (void)unlikePostInBackground:(PFObject *)post
                         block:(void (^)(BOOL succeeded,
                                         NSError *error))completionBlock;
+ (void)reportPostInBackground:(PFObject *)post
                         block:(void (^)(BOOL succeeded,
                                         NSError *error))completionBlock;

+ (void)likeComment:(PFObject *)post;
+ (void)unlikeComment:(PFObject *)post;
+ (void)likeCommentInBackground:(PFObject *)post
                          block:(void (^)(BOOL succeeded,
                                          NSError *error))completionBlock;
+ (void)unlikeCommentInBackground:(PFObject *)post
                            block:(void (^)(BOOL succeeded,
                                            NSError *error))completionBlock;
+ (void)reportCommentInBackground:(PFObject *)post
                            block:(void (^)(BOOL succeeded,
                                            NSError *error))completionBlock;

+ (void)followPostInBackground:(PFObject *)post
                         block:(void (^)(BOOL succeeded,
                                         NSError *error))completionBlock;
+ (void)unfollowPostInBackground:(PFObject *)post
                           block:(void (^)(BOOL succeeded,
                                           NSError *error))completionBlock;

+ (PFObject *)getCompanyObject:(NSString *)objectId;
+ (PFObject *)getPostObject:(NSString *)objectId;

@end
