//
//  AddFriendViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 01-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "AddFriendViewController.h"
#import "Parse/Parse.h"
#import "OuiItemViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigation controller to only back button
    self.navigationController.navigationBar.topItem.title = @"";

    // Set colors
    UIColor *color = [UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0];
    
    // Style input fields
    self.email.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.email.layer.borderWidth = 2.0;
    UIView *emailPaddingInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.email.leftView = emailPaddingInput;
    self.email.leftViewMode = UITextFieldViewModeAlways;
    self.email.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email address" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Get data
    [self retrieveData];

}

-(void)viewDidAppear:(BOOL)animated{
    // Reload UIpicker
    [self.friendPicker reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)retrieveData{
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"Follow"];
    [ouiItems whereKey:@"user1" equalTo:user];
    
    [ouiItems orderByDescending:@"createdAt"];
    ouiItems.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            // Set objects in ouItemsDB array
            self.friendsArray = [[NSArray alloc] initWithArray:objects];
           
        }else{
            NSLog(@"error");
        }
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    // Component to 1
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    // Return count friendsArray
    return [self.friendsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // Return emails followers
    return [[self.friendsArray objectAtIndex:row] valueForKey:@"name"];
}
@end
