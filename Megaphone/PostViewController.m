//
//  PostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostViewController.h"
#import "PostCell.h"
#import "CommentTableViewCell.h"
#import "ProfileImageView.h"
#import "GTScrollNavigationBar.h"

#define MIN_LIKES -3
#define MAX_REPORTS 5

@interface PostViewController () {
    NSMutableArray *comments;
    PFObject *pressed_comment;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *postToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
- (IBAction)postComment:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet ProfileImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButtonOutlet;
- (IBAction)favorite:(id)sender;

@end

@implementation PostViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLabel.text = _postObj[@"title"];
    _descriptionLabel.text = _postObj[@"description"];
    PFUser *author = _postObj[@"user"];
    [author fetchIfNeeded];
    _authorLabel.text = author[@"name"];

    [_authorImageView setImageWithLink:author[@"imageLink"]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@ %@", [_postObj[@"type"] uppercaseString], @"For", [_postObj[@"company"] uppercaseString]];
    
    [self containsUser:_postObj relationType:@"followers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [_favoriteButtonOutlet setImage:[UIImage imageNamed:@"ios7-star-1"] forState:UIControlStateNormal];
        }else {
            [_favoriteButtonOutlet setImage:[UIImage imageNamed:@"ios7-star-outline-1"] forState:UIControlStateNormal];
        }
    }];
    
    //long press
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [_commentTableView addGestureRecognizer:lpgr];

    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTextField.delegate = self;
    _commentTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self getComments];
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
    
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
    _followersCountLabel.text = [_postObj[@"numFollowers"] stringValue];
    
    //Check if user likes the post
    [self containsUser:_postObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
    self.tabBarController.tabBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) liftMainViewWhenKeybordAppears:(NSNotification*)aNotification{
    [self scrollViewForKeyboard:aNotification up:YES];
}

- (void) returnMainViewToInitialposition:(NSNotification*)aNotification{
    [self scrollViewForKeyboard:aNotification up:NO];
}

- (void) scrollViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (keyboardFrame.size.height * (up?-1:1)), self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_commentTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *comment = [comments objectAtIndex:indexPath.row];
    [comment fetchIfNeeded];
    
    PFUser *author = comment[@"user"];
    
    // Circular Image
    NSURL *profileLink = [NSURL URLWithString:author[@"imageLink"]];
    UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:profileLink]];
    cell.profileImageView.image = profileImage;
    cell.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height / 2;
    cell.profileImageView.layer.masksToBounds = YES;
    cell.profileImageView.layer.borderWidth = 0;
    
    cell.nameLabel.text = author[@"name"];
    cell.commentLabel.text = comment[@"comment"];
    cell.timeLabel.text = comment[@"timeStamp"];
    cell.commentObj = comment;
    //Check if user likes the post
    [self containsUser:comment relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [cell.likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
        }else {
            [cell.likeButtonOutlet setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
        }
    }];
    cell.numLikesLabelOutlet.text = [comment[@"numLikes"] stringValue];
    return cell;
}

-(void)uploadCommentToParse
{
    PFObject *comment = [PFObject objectWithClassName:@"Comments"];
    [comment setObject:_commentTextField.text forKey:@"comment"];
    comment[@"numLikes"] = [NSNumber numberWithInt:0];
    comment[@"numReports"] = [NSNumber numberWithInt:0];
    comment[@"company"] = _postObj[@"company"];
    [comment setObject:[NSNumber numberWithBool:NO] forKey:@"reported"];
    [comment setObject:[PFUser currentUser] forKey:@"user"];
    [comment setObject:_postObj forKey:@"post"];

    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MM/dd/YYYY"];
    NSString *date_String=[dateformater stringFromDate:[NSDate date]];
    comment[@"timeStamp"] = date_String;
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
    comment[@"usernameId"] = currentUser.objectId;
    comment[@"username"] = currentUser[@"username"];
    
    [comment saveInBackground];
    
    PFRelation *relation = [_postObj relationForKey:@"commenters"];
    [relation addObject:[PFUser currentUser]];
    [_postObj incrementKey:@"numComments" byAmount:[NSNumber numberWithInt:1]];
    [_postObj saveInBackground];
    
    [self getComments];
    [self.commentTableView setNeedsDisplay];
    [_commentTableView reloadData];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    _commentTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)containsUser:(PFObject *)myObject relationType:(NSString *)relationType block:(void (^)(BOOL, NSError *))completionBlock {
    PFRelation *relation = [myObject relationForKey:relationType];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [query countObjectsInBackgroundWithBlock: ^(int count, NSError *error) {
        completionBlock(count > 0, error);
    }];
}

- (IBAction)upButtonPressed:(id)sender {
    
    [self containsUser:_postObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnliked];
        } else {
            [self changeToLiked];
        }
    }];
}

- (IBAction)actionSheetPressed:(id)sender {
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    BOOL isAuthor = [[PFUser currentUser].objectId isEqualToString:_postObj[@"usernameId"]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:(isAuthor ? @"Delete" : @"Report")
                                                    otherButtonTitles:@"Share", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self reportOrDeletePost];
            break;
        case 1:
            [self sharePost];
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (void)reportOrDeletePost {
    BOOL isAuthor = [[PFUser currentUser].objectId isEqualToString:_postObj[@"usernameId"]];
    
    if(isAuthor){
        [_postObj deleteInBackground];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Deleted"
                                                        message:@"Your post was successfully deleted."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self containsUser:_postObj relationType:@"reporters" block: ^(BOOL contains, NSError *error) {
            if (contains) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Reported"
                                                                message:@"You have already reported this post."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                PFRelation *relation = [_postObj relationForKey:@"reporters"];
                [relation addObject:[PFUser currentUser]];
                [_postObj incrementKey:@"numReports" byAmount:[NSNumber numberWithInt:1]];
                [_postObj save];
                if ([_postObj[@"numReports"] integerValue] >= MAX_REPORTS) {
                    [_postObj deleteInBackground];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Reported"
                                                                message:@"This post was successfully reported."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)sharePost {
    //TODO: share
}

- (void)changeToLiked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
    NSLog(@"change to liked");
}

- (void)changeToUnliked {
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation removeObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save];
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
    NSLog(@"change to liked");
}

- (IBAction)postComment:(id)sender {
    
    if ([_commentTextField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing comment"
                                                        message:@"Please enter a comment."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"upload to parse called");
        [self uploadCommentToParse];
    }
}

- (void)getComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query includeKey:@"user"];
    [query whereKey:@"post" equalTo:_postObj];
    query.limit = 30;
    comments = [NSMutableArray arrayWithArray:[query findObjects]];
}

- (IBAction)favorite:(id)sender {
    [self containsUser:_postObj relationType:@"followers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToUnfollowed];
        } else {
            [self changeToFollowed];
        }
    }];
}

- (void)changeToFollowed {
    [_favoriteButtonOutlet setImage:[UIImage imageNamed:@"ios7-star-1"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    [relation addObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    _followersCountLabel.text = [_postObj[@"numFollowers"] stringValue];
}

- (void)changeToUnfollowed {
    [_favoriteButtonOutlet setImage:[UIImage imageNamed:@"ios7-star-outline-1"] forState:UIControlStateNormal];
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    [relation removeObject:[PFUser currentUser]];
    
    [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save];
    _followersCountLabel.text = [_postObj[@"numFollowers"] stringValue];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:_commentTableView];
        NSIndexPath *indexPath = [_commentTableView indexPathForRowAtPoint:p];
        
        if (indexPath) {
            UIAlertView *alert;
            pressed_comment = [comments objectAtIndex:indexPath.row];
            BOOL isAuthor = [[PFUser currentUser].objectId isEqualToString:pressed_comment[@"usernameId"]];

            if (isAuthor){
                 alert = [[UIAlertView alloc] initWithTitle:@"Delete your comment?"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Delete", nil];
            }else{
                alert = [[UIAlertView alloc] initWithTitle:@"Report this comment?"
                                                                message:@"Is this comment innapropriate or against our guidelines?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Report", nil];
            }
            alert.tag = 100;
            [alert show];
        }
    }
}


- (void)reportOrDeleteComment {
    if(!pressed_comment) return;
    BOOL isAuthor = [[PFUser currentUser].objectId isEqualToString:pressed_comment[@"usernameId"]];
    
    if(isAuthor){
        [pressed_comment deleteInBackground];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment Deleted"
                                                        message:@"Your comment was successfully deleted."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self getComments];
        [self.commentTableView setNeedsDisplay];
        [_commentTableView reloadData];
    }else{
        [self containsUser:pressed_comment relationType:@"reporters" block: ^(BOOL contains, NSError *error) {
            if (contains) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment Reported"
                                                                message:@"You have already reported this comment."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                PFRelation *relation = [pressed_comment relationForKey:@"reporters"];
                [relation addObject:[PFUser currentUser]];
                [pressed_comment incrementKey:@"numReports" byAmount:[NSNumber numberWithInt:1]];
                [pressed_comment save];
                if ([pressed_comment[@"numReports"] integerValue] >= MAX_REPORTS) {
                    [pressed_comment deleteInBackground];
                }
            }
        }];
    }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self reportOrDeleteComment];
                break;
            default:
                break;
        }
    }
}


@end
