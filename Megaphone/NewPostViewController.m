//
//  NewPostViewController.m
//  Megaphone
//
//  Created by Myles Scolnick on 4/10/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (sender == self.cancelButton) return;
    else if (sender == self.saveButton){
        //TODO: send anything back if we need
    }

}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)savePressed:(id)sender {
    //TODO: Add the post to parse
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
