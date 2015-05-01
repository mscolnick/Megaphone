//
//  PostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostViewController.h"
#import "PostCell.h"

#define MIN_LIKES -3
#define MAX_REPORTS 5

@interface PostViewController () {
    NSMutableArray *comments;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *postToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
- (IBAction)postComment:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@end

@implementation PostViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLabel.text = _postObj[@"title"];
    _descriptionLabel.text = _postObj[@"description"];
    //_typeLabel.text = [_postObj[@"type"] uppercaseString];
    //_companyLabel.text = [_postObj[@"company"] uppercaseString];
    _authorLabel.text = [NSString stringWithFormat:@"%@ %@", _postObj[@"first_name"], [_postObj[@"last_name"] substringToIndex:1]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@ %@", [_postObj[@"type"] uppercaseString], @"For", [_postObj[@"company"] uppercaseString]];
    
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTextField.delegate = self;
    _commentTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    comments = _postObj[@"comments"];
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
    _followersCountLabel.text = [_postObj[@"numFollowers"] stringValue];
    
    //Check if user likes the post
    __block BOOL canSkip = NO;
    [self containsUser:_postObj relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [self changeToLiked];
            canSkip = YES;
        }
    }];
    if (!canSkip) {
        [self containsUser:_postObj relationType:@"dislikers" block: ^(BOOL contains, NSError *error) {
            if (contains) {
                [self changeToDisliked];
            }
        }];
    }
    
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
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
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    PFObject *comment = [comments objectAtIndex:indexPath.row];
    [comment fetchIfNeeded];
    cell.textLabel.text = comment[@"comment"];
    cell.numLikesLabel.text = [comment[@"numLikes"] stringValue];
    
    //Check if user likes the post
    __block BOOL canSkip = NO;
    [self containsUser:comment relationType:@"likers" block: ^(BOOL contains, NSError *error) {
        if (contains) {
            [cell changeToLiked];
            canSkip = YES;
        }
    }];
    if (!canSkip) {
        [self containsUser:comment relationType:@"dislikers" block: ^(BOOL contains, NSError *error) {
            if (contains) {
                [cell changeToDisliked];
            }
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [_postObj addObject:comment forKey:@"comments"];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"MM/dd/YYYY"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    comment[@"timeStamp"] = date_String;
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
    NSString *objID = [currentUser objectId];
    comment[@"usernameId"] = objID;
    comment[@"username"] = currentUser[@"username"];
    
    [_postObj saveInBackground];
    [comment saveInBackground];
    
    comments = _postObj[@"comments"];
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
    NSLog(@"up button");
    [self changeToLiked];
    PFRelation *relation = [_postObj relationForKey:@"likers"];
    [relation addObject:[PFUser currentUser]];
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
}

- (IBAction)downButtonPressed:(id)sender {
    NSLog(@"down button");
    [self changeToDisliked];
    PFRelation *relation = [_postObj relationForKey:@"dislikers"];
    [relation addObject:[PFUser currentUser]];
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    NSNumber *numLikes = _postObj[@"numLikes"];
    if ([numLikes integerValue] <= MIN_LIKES) {
        [_postObj deleteInBackground];
    }
    else {
        [_postObj save];
    }
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
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

- (void)reportPost {
    [_postObj incrementKey:@"numReports" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save];
    if ([_postObj[@"numLikes"] integerValue] >= MAX_REPORTS) {
        _postObj[@"reported"] = [NSNumber numberWithBool:YES];
    }
}

- (void)followPost {
    PFRelation *relation = [_postObj relationForKey:@"followers"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    BOOL following = [query countObjects] > 0;
    
    if (following) {
        [relation removeObject:[PFUser currentUser]];
        [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:-1]];
    }
    else {
        [relation addObject:[PFUser currentUser]];
        [_postObj incrementKey:@"numFollowers" byAmount:[NSNumber numberWithInt:1]];
    }
    [_postObj save];
}

- (void)sharePost {
    //TODO: share
}

- (void)changeToLiked {
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_upButton setImage:[UIImage imageNamed:@"ios7-arrow-up-green"] forState:UIControlStateNormal];
}

- (void)changeToDisliked {
    _upButton.userInteractionEnabled = NO;
    _downButton.userInteractionEnabled = NO;
    [_downButton setImage:[UIImage imageNamed:@"ios7-arrow-down-red"] forState:UIControlStateNormal];
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
@end
