//
//  MegaphoneUtility.m
//  Megaphone
//
//  Created by Myles Scolnick on 5/11/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "MegaphoneUtility.h"

#define MAX_REPORTS 5

@implementation MegaphoneUtility

#pragma mark Contains User

+ (void)containsUserInBackground:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock {
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock: ^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

+ (BOOL)containsUser:(PFObject *)myObject relationType:(NSString *)relationType {
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    return [query countObjects] > 0;
}

#pragma mark Posts

+ (void) likePost:(PFObject *)post{
    PFRelation *relation = [post relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    [post incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [post save];
}

+ (void) likePostInBackground:(PFObject *)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFRelation *relation = [post relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    [post incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(succeeded, error);
    }];
}

+ (void) unlikePost:(PFObject *)post{
    PFRelation *relation = [post relationForKey:@"likers"];
    [relation removeObject:[PFUser currentUser]];
    [post incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [post save];
}

+ (void) unlikePostInBackground:(PFObject *)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFRelation *relation = [post relationForKey:@"likers"];
    [relation removeObject:[PFUser currentUser]];
    [post incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(succeeded, error);
    }];
}

+ (void) reportPostInBackground:(PFObject *)post block:(void (^)(BOOL, NSError *))completionBlock{
    PFRelation *relation = [post relationForKey:@"reporters"];
    [relation addObject:[PFUser currentUser]];
    [post incrementKey:@"numReports" byAmount:[NSNumber numberWithInt:1]];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if([post[@"numReports"] integerValue] >= MAX_REPORTS){
            [post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                completionBlock(succeeded, error);
            }];
        }
    }];
}


#pragma mark Comments

+ (void) likeComment:(PFObject *)comment{
    [MegaphoneUtility likePost:comment];
}

+ (void) likeCommentInBackground:(PFObject *)comment block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    [MegaphoneUtility likePostInBackground:comment block:completionBlock];
}

+ (void) unlikeComment:(PFObject *)comment{
    [MegaphoneUtility unlikePost:comment];
}

+ (void) unlikeCommentInBackground:(PFObject *)comment block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    [MegaphoneUtility unlikePostInBackground:comment block:completionBlock];
}

+ (void) reportCommentInBackground:(PFObject *)comment block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    [MegaphoneUtility reportPostInBackground:comment block:completionBlock];
}



#pragma mark Following

+ (void) followPostInBackground:(PFObject *)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFRelation *relation = [post relationForKey:@"followers"];
    [relation addObject:[PFUser currentUser]];
    [post incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:1]];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(succeeded, error);
    }];
}

+ (void) unfollowPostInBackground:(PFObject *)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFRelation *relation = [post relationForKey:@"followers"];
    [relation removeObject:[PFUser currentUser]];
    [post incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:-1]];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionBlock(succeeded, error);
    }];
}

@end