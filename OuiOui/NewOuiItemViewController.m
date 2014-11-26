//
//  NewOuiItemViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "NewOuiItemViewController.h"
#import "Parse/Parse.h"

@interface NewOuiItemViewController ()

@end

@implementation NewOuiItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.parentViewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // Set navigation controller to only back button
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"OuiOui";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Set placeholdertext color
    UIColor *color = [UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0];
    
    // Style input fields
    self.ouiItem.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.ouiItem.layer.borderWidth = 2.0;
    UIView *ouiItemPaddingInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.ouiItem.leftView = ouiItemPaddingInput;
    self.ouiItem.leftViewMode = UITextFieldViewModeAlways;
    self.ouiItem.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Oui item" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.ouiDescription.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.ouiDescription.layer.borderWidth = 2.0;
    self.ouiDescription.attributedText = [[NSAttributedString alloc]initWithString:@"Oui description" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addOuiItem:(id)sender {
    
    // Check if user input fields are correctly filled
    if ([self.ouiItem.text length] < 2 || [self.ouiDescription.text length] < 2) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid Entry"
                              message:@"Title and description must both be at least 2 characters long."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    } else {
        // Create new object
        PFObject *ouiItem = [PFObject objectWithClassName:@"OuiItem"];
    
        // Get user
        PFUser *user = [PFUser currentUser];
        [ouiItem setObject:user forKey:@"user"];
    
        // Set title and description
        ouiItem[@"title"] = self.ouiItem.text;
        ouiItem[@"description"] = self.ouiDescription.text;
        ouiItem[@"checked"] = [NSNumber numberWithBool:NO];
    
        // Save Oui item
        if([ouiItem save]){
            // Return to overview Oui items
            [self.navigationController popToRootViewControllerAnimated:true];
        }else{
            // Can't save new Oui item
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Not saved"
                                  message:@"We could not save your Oui item, try again."
                                  delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
        
            [alert show];

        }
    }
}

@end