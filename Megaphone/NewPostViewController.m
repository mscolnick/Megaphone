//
//  NewPostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Scolnick. All rights reserved.
//

#import "NewPostViewController.h"

#define MAX_TITLE_LENGTH 30
#define MAX_DESCRIPTION_LENGTH 150

#define postTypes(int) [@[@"feature", @"bug", @"idea",  @"other"] objectAtIndex: int]

@interface NewPostViewController () {
    int selectedSegment;
    NSString *postType;
}

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryField;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleField.delegate = self;
    _descriptionField.delegate = self;
    selectedSegment = 0;
    postType = postTypes(0); // feature
    _companyLabel.text = [_companyObj[@"name"] uppercaseString];
    CGRect frameRect = _descriptionField.frame;
    frameRect.size.height = 53;
    _descriptionField.frame = frameRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_titleField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if ([textField.restorationIdentifier isEqualToString:@"titleTextField"]) {
        return newLength <= MAX_TITLE_LENGTH;
    }
    else if ([textField.restorationIdentifier isEqualToString:@"descriptionTextField"]) {
        return newLength <= MAX_DESCRIPTION_LENGTH;
    }
    else {
        return YES;
    }
}

- (void)uploadPostToParse {
    PFObject *post = [PFObject objectWithClassName:kPostsClassKey];
    post[kPostsNumLikesKey] = [NSNumber numberWithInt:0];
    post[kPostsNumReportsKey] = [NSNumber numberWithInt:0];
    post[kPostsNumFollowersKey] = [NSNumber numberWithInt:0];
    post[kPostsNumCommentsKey] = [NSNumber numberWithInt:0];
    post[kPostsTitleKey] = _titleField.text;
    post[kPostsDescriptionKey] = _descriptionField.text;
    post[kPostsCompanyKey] = _companyObj[@"name"];
    post[kPostsCompanyIdKey] = _companyObj.objectId;
    post[kPostsReportedKey] = [NSNumber numberWithBool:NO];
    post[kPostsTypeKey] = postType;
    
    PFUser *currentUser = [PFUser currentUser];
    post[kUserKey] = currentUser;
    post[kUsernameIdKey] = currentUser.objectId;
    post[kUsernameKey] = currentUser[@"username"];
    NSNumber *num = currentUser[kCompanyNumPostsKey];
    post[@"number"] = [NSNumber numberWithInt:[num intValue] + 1];
    post[kPostsFirstNameKey] = currentUser[kPostsFirstNameKey];
    post[kPostsLastNameKey] = currentUser[kPostsLastNameKey];
    
    [post saveInBackground];
    
    [_companyObj incrementKey:kCompanyNumPostsKey];
    [_companyObj addObject:post forKey:kPostsClassKey];
    [_companyObj saveInBackground];
    
    [currentUser incrementKey:@"numQuestions"];
    currentUser[@"karma"] = [NSNumber numberWithInt:([currentUser[@"karma"] intValue] + 2)];
    [currentUser saveInBackground];
    
    [self resetFields];
}

- (void)resetFields {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Sent"
                                                    message:@"Your post has been successfully uploaded!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    _titleField.text = @"";
    _descriptionField.text = @"";
}

//To dismiss keyboard when touched outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender {
    if ([_titleField.text isEqual:@""] || [_descriptionField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing post or title"
                                                        message:@"Please enter a title and description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self uploadPostToParse];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    postType = postTypes(segment);
    selectedSegment = (int)segment;
}

@end
