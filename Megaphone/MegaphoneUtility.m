//
//  MegaphoneUtility.m
//  Megaphone
//
//  Created by Myles Scolnick on 5/11/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "MegaphoneUtility.h"

#define MAX_REPORTS 5

@implementation MegaphoneUtility

#pragma mark Contains User

+ (void)containsUserInBackground:(PFObject *)myObject
                    relationType:(NSString *)relationType
                           block:(void (^)(BOOL, NSError *))completionBlock {
  PFRelation *relation = [myObject relationForKey:relationType];
  PFQuery *query = [relation query];
  [query whereKey:kObjectIdKey equalTo:[PFUser currentUser].objectId];
  [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
    completionBlock(count > 0, error);
  }];
}

+ (BOOL)containsUser:(PFObject *)myObject
        relationType:(NSString *)relationType {
  PFRelation *relation = [myObject relationForKey:relationType];
  PFQuery *query = [relation query];
  [query whereKey:kObjectIdKey equalTo:[PFUser currentUser].objectId];
  return [query countObjects] > 0;
}

#pragma mark Posts

+ (void)likePost:(PFObject *)post {
  PFRelation *relation = [post relationForKey:kRelationLikers];
  [relation addObject:[PFUser currentUser]];
  [post incrementKey:@"numLikes" byAmount:@1];
  [post save];
}

+ (void)likePostInBackground:(PFObject *)post
                       block:(void (^)(BOOL succeeded,
                                       NSError *error))completionBlock {
  PFRelation *relation = [post relationForKey:kRelationLikers];
  [relation addObject:[PFUser currentUser]];
  [post incrementKey:@"numLikes" byAmount:@1];
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    completionBlock(succeeded, error);
  }];
}

+ (void)unlikePost:(PFObject *)post {
  PFRelation *relation = [post relationForKey:kRelationLikers];
  [relation removeObject:[PFUser currentUser]];
  [post incrementKey:@"numLikes" byAmount:@1];
  [post save];
}

+ (void)unlikePostInBackground:(PFObject *)post
                         block:(void (^)(BOOL succeeded,
                                         NSError *error))completionBlock {
  PFRelation *relation = [post relationForKey:kRelationLikers];
  [relation removeObject:[PFUser currentUser]];
  [post incrementKey:@"numLikes" byAmount:@-1];
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    completionBlock(succeeded, error);
  }];
}

+ (void)reportPostInBackground:(PFObject *)post
                         block:(void (^)(BOOL, NSError *))completionBlock {
  PFRelation *relation = [post relationForKey:kRelationReporters];
  [relation addObject:[PFUser currentUser]];
  [post incrementKey:@"numReports" byAmount:@1];
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if ([post[@"numReports"] integerValue] >= MAX_REPORTS) {
      [post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(succeeded, error);
      }];
    }
  }];
}

#pragma mark Comments

+ (void)likeComment:(PFObject *)comment {
  [MegaphoneUtility likePost:comment];
}

+ (void)likeCommentInBackground:(PFObject *)comment
                          block:(void (^)(BOOL succeeded,
                                          NSError *error))completionBlock {
  [MegaphoneUtility likePostInBackground:comment block:completionBlock];
}

+ (void)unlikeComment:(PFObject *)comment {
  [MegaphoneUtility unlikePost:comment];
}

+ (void)unlikeCommentInBackground:(PFObject *)comment
                            block:(void (^)(BOOL succeeded,
                                            NSError *error))completionBlock {
  [MegaphoneUtility unlikePostInBackground:comment block:completionBlock];
}

+ (void)reportCommentInBackground:(PFObject *)comment
                            block:(void (^)(BOOL succeeded,
                                            NSError *error))completionBlock {
  [MegaphoneUtility reportPostInBackground:comment block:completionBlock];
}

#pragma mark Following

+ (void)followPostInBackground:(PFObject *)post
                         block:(void (^)(BOOL succeeded,
                                         NSError *error))completionBlock {
  PFRelation *relation = [post relationForKey:kRelationFollowers];
  [relation addObject:[PFUser currentUser]];
  [post incrementKey:kPostsNumFollowersKey byAmount:@1];
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    completionBlock(succeeded, error);
  }];
}

+ (void)unfollowPostInBackground:(PFObject *)post
                           block:(void (^)(BOOL succeeded,
                                           NSError *error))completionBlock {
  PFRelation *relation = [post relationForKey:kRelationFollowers];
  [relation removeObject:[PFUser currentUser]];
  [post incrementKey:kPostsNumFollowersKey byAmount:@-1];
  [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    completionBlock(succeeded, error);
  }];
}

#pragma mark Lookup by Id

+ (PFObject *)getCompanyObject:(NSString *)objectId {
  PFQuery *query = [PFQuery queryWithClassName:kCompanyClassKey];
  query.limit = 1;
  [query whereKey:kObjectIdKey equalTo:objectId];
  NSArray *objs = [query findObjects][0];
  if ([objs count] > 0) {
    return objs[0];
  }
  return nil;
}

+ (PFObject *)getPostObject:(NSString *)objectId {
  PFQuery *query = [PFQuery queryWithClassName:kPostsClassKey];
  query.limit = 1;
  [query whereKey:kObjectIdKey equalTo:objectId];
  NSArray *objs = [query findObjects][0];
  if ([objs count] > 0) {
    return objs[0];
  }
  return nil;
}
@end
