//
//  NewPostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController () {
    int selectedSegment;
    NSString *postType;
}

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryField;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleField.delegate = self;
    _descriptionField.delegate = self;
    selectedSegment = 0;
    postType = @"feature";
    _descriptionField.text = @"Enter description here...";
    _descriptionField.textColor = [UIColor whiteColor];
    _companyLabel.text = _companyObj[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_titleField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_descriptionField.text isEqualToString:@"Enter description here..."]) {
        _descriptionField.text = @"";
        _descriptionField.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_descriptionField.text isEqualToString:@""]) {
        _descriptionField.text = @"Enter description here...";
       _descriptionField.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 30;
}

-(void)uploadPostToParse
{
    NSLog(@"uploadQuestionToParse method");
    PFObject *post = [PFObject objectWithClassName:@"Posts"];
    post[@"numLikes"] = [NSNumber numberWithInt:0];
    post[@"numReports"] = [NSNumber numberWithInt:0];
    post[@"title"] = _titleField.text;
    post[@"description"] = _descriptionField.text;
    post[@"company"] = _companyObj[@"name"];
    [post setObject:[NSNumber numberWithBool:NO] forKey:@"reported"];
    post[@"type"] = postType;
    
    PFUser *currentUser = [PFUser currentUser];
    post[@"user"] = currentUser;
    NSString *objID = [currentUser objectId];
    post[@"usernameId"] = objID;
    post[@"username"] = currentUser[@"username"];
    PFUser *user = [post objectForKey:@"user"];
    NSNumber *num = [user objectForKey:@"numPosts"];
    post[@"number"] = [NSNumber numberWithInt:[num intValue] + 1];
    [post saveInBackground];
    
    [_companyObj incrementKey:@"numPosts" byAmount:[NSNumber numberWithInt:1]];
    [_companyObj addObject:post forKey:@"posts"];
    [_companyObj saveInBackground];
    
    [currentUser incrementKey:@"numQuestions"];
    currentUser[@"karma"] = [NSNumber numberWithInt:([currentUser[@"karma"] intValue] + 2)];
    [currentUser saveInBackground];
    
    [self resetAsk];
}


-(void)resetAsk
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Sent"
                                                    message:@"Your post has been successfully uploaded!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    _titleField.text = @"";
    _descriptionField.text = @"";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if (sender == self.cancelButton) return;
//    else if (sender == self.saveButton){
//        //TODO: send anything back if we need
//    }

}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)savePressed:(id)sender {
    //TODO: Add the post to parse
    NSLog(@"askButtonClicked");
    if ([_titleField.text isEqual:@""] || [_descriptionField.text isEqual:@""] || [_descriptionField.text isEqual:@"Enter description here..." ]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing post or title"
                                                        message:@"Please enter a title and description."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"upload to parse called");
        [self uploadPostToParse];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    if (segment == 0) {
        selectedSegment = 0;
        postType = @"feature";
    } else if (segment == 1) {
        selectedSegment = 1;
        postType = @"bug";
    } else if (segment == 2) {
        selectedSegment = 2;
        postType = @"idea";
    } else if (segment == 3) {
        selectedSegment = 3;
        postType = @"other";
    }
}

@end
