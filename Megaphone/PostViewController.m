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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //TODO: if user not equal to author and has not voted
    //then increase count and set up-button to green and set both buttons inactive
    NSLog(@"up button");
    _upButton.enabled = NO;
    _downButton.enabled = NO;
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
}
- (IBAction)downButtonPressed:(id)sender {
    //TODO: if user not equal to author and has not voted
    //then decrease count and set down-button to red and set both buttons inactive
    NSLog(@"down button");
    _upButton.enabled = NO;
    _downButton.enabled = NO;
    
    [_postObj incrementKey:@"numLikes" byAmount:[NSNumber numberWithInt:-1]];
    [_postObj save]; // cannot use saveInBackground because want to make sure it is save before reloading
    _countLabel.text = [_postObj[@"numLikes"] stringValue];
}


- (IBAction)actionSheetPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                delegate:self
                cancelButtonTitle:@"Cancel"
                destructiveButtonTitle:@"Report"
                otherButtonTitles:@"Follow", @"Share", nil];
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
    //TODO: add post to list of users follwing posts
}
- (void)sharePost{
    //TODO: share
}

@end
