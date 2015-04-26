//
//  PostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostViewController.h"

const int MAX_REPORTS = 5;

@interface PostViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end

@implementation PostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _titleLabel.text = _postObj[@"title"];
    _descriptionLabel.text = _postObj[@"description"];
    _typeLabel.text = _postObj[@"type"];
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
    _companyLabel.text = _postObj[@"company"];
    _authorLabel.text = [NSString stringWithFormat:@"%@ %@", _postObj[@"first_name"], [_postObj[@"last_name"] substringToIndex:1]];
    //TODO: if user has already voted, then set buttons to inactive
    
    //Check if user likes the post
    __block BOOL canSkip = NO;
    [self containsUser:_postObj relationType:@"likers" block:^(BOOL contains,NSError* error) {
        if (contains){
            NSLog(@"User in likers");
            [self changeToLiked];
            canSkip = YES;
        }
    }];
    if (canSkip) {
        [self containsUser:_postObj relationType:@"dislikers" block:^(BOOL contains,NSError* error) {
            if (contains){
                NSLog(@"User in dislikers");
                [self changeToDisliked];
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)containsUser:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock
{
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)upButtonPressed:(id)sender {
    NSLog(@"up button");
    [self changeToLiked];
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
}
- (IBAction)downButtonPressed:(id)sender {
    NSLog(@"down button");
    [self changeToDisliked];
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
}


- (IBAction)actionSheetPressed:(id)sender {
    
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    BOOL following = [query countObjects] > 0;
     
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                delegate:self
                cancelButtonTitle:@"Cancel"
                destructiveButtonTitle:@"Report"
                otherButtonTitles:(following ? @"Un-follow" : @"Follow"), @"Share", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex)
    {
        case 0:
            NSLog(@"report");
            [self reportPost];
            break;
        
        case 1:
            NSLog(@"follow");
            [self followPost];
            break;
            
        case 2:
            NSLog(@"share");
            [self sharePost];
            break;
            
        case 3:
            NSLog(@"cancel");
            break;
            
        default:
            break;
            
    }
}

- (void)reportPost{
    [_postObj incrementKey:@"numReports" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    if ([_postObj[@"numLikes"] integerValue] >= MAX_REPORTS){
        _postObj[@"reported"] = [NSNumber numberWithBool:YES];
    }
}
- (void)followPost{
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    BOOL following = [query countObjects] > 0;
    
    if (following) {
        [relation removeObject:[PFUser currentUser]];
        [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:-1]];
    }else{
        [relation addObject:[PFUser currentUser]];
        [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:1]];
    }
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
}
- (void)sharePost{
    //TODO: share
}

- (void) changeToLiked{
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
}

- (void) changeToDisliked{
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_downButton setImage:[UIImage imageNamed:@"ios7-arrow-down-red"] forState:UIControlStateNormal];
}

@end
