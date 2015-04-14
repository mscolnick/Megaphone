//
//  PostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/13/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "PostViewController.h"

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
//    PFUser *user = [_postObj objectForKey:@"user"];
    //TODO: Get user name
//    NSString *username= [user objectForKey:@"name"];
//    NSString *username = [NSString stringWithFormat:@"%@ %@", user[@"first_name"], [user[@"last_name"] substringToIndex:1]];
//    _authorLabel.text = username;
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
    _upButton.enabled = NO;
    _upButton.backgroundColor = [UIColor greenColor];
    _downButton.enabled = NO;
}
- (IBAction)downButtonPressed:(id)sender {
    //TODO: if user not equal to author and has not voted
    //then decrease count and set down-button to red and set both buttons inactive
    _upButton.enabled = NO;
    _downButton.enabled = NO;
    _downButton.backgroundColor = [UIColor redColor];

}


@end
