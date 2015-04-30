//
//  NewPostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "NewPostViewController.h"

#define MAX_TITLE_LENGTH 30
#define MAX_DESCRIPTION_LENGTH 150


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
    postType = @"feature";
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
    NSLog(@"Uploading to parse...");
    PFObject *post = [PFObject objectWithClassName:@"Posts"];
    post[@"numLikes"] = [NSNumber numberWithInt:0];
    post[@"numReports"] = [NSNumber numberWithInt:0];
    post[@"numFollowers"] = [NSNumber numberWithInt:0];
    post[@"title"] = _titleField.text;
    post[@"description"] = _descriptionField.text;
    post[@"company"] = _companyObj[@"name"];
    post[@"reported"] = [NSNumber numberWithBool:NO];
    post[@"type"] = postType;
    
    PFUser *currentUser = [PFUser currentUser];
    post[@"user"] = currentUser;
    post[@"usernameId"] = currentUser.objectId;
    post[@"username"] = currentUser[@"username"];
    NSNumber *num = currentUser[@"numPosts"];
    post[@"number"] = [NSNumber numberWithInt:[num intValue] + 1];
    post[@"first_name"] = currentUser[@"first_name"];
    post[@"last_name"] = currentUser[@"last_name"];
    
    [post saveInBackground];
    
    [_companyObj incrementKey:@"numPosts" byAmount:[NSNumber numberWithInt:1]];
    [_companyObj addObject:post forKey:@"posts"];
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
    //TODO: Add the post to parse
    NSLog(@"Sumbite Button Clicked");
    if ([_titleField.text isEqual:@""] || [_descriptionField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing post or title"
                                                        message:@"Please enter a title and description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"upload to parse called");
        [self uploadPostToParse];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    if (segment == 0) {
        postType = @"feature";
    }
    else if (segment == 1) {
        postType = @"bug";
    }
    else if (segment == 2) {
        postType = @"idea";
    }
    else if (segment == 3) {
        postType = @"other";
    }
    selectedSegment = (int)segment;
}

@end
