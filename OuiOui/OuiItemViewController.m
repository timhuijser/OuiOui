//
//  NewOuiItemViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "OuiItemViewController.h"
#import "Parse/Parse.h"
#import "GPUImage.h"
#import "AddFriendViewController.h"

@interface OuiItemViewController ()

@end

@implementation OuiItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Style navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // Set colors
    UIColor *color = [UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0];
       
    // Set navigation controller to only back button
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"OuiOui";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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
    self.ouiDescription.textContainer.lineFragmentPadding = 20;
    self.ouiDescription.delegate = self;
    
    if(self.item){
        [self.actionButton setTitle:@"Update Oui" forState:UIControlStateNormal];
        [self.actionButton setTag:1];
        [self.ouiItem setText:[NSString stringWithFormat:@"%@", [self.item valueForKey:@"title"]]];
        [self.ouiDescription setText:[NSString stringWithFormat:@"%@", [self.item valueForKey:@"descriptionItem"]]];
        self.ouiItemId = [self.item valueForKey:@"objectId"];
        
        if ((int)[self.item valueForKey:@"checked"] == 1) {
            [self.done setOn:YES animated:YES];
        } else {
            [self.done setOn:NO animated:YES];
        }
        
        [self.addFriend setHidden:TRUE];

        self.doneLabel.text = @"Done";
        
        // Get current user
        PFUser *user = [PFUser currentUser];
        
        // Check if user owner is of item
        if(![[[self.item valueForKey:@"user"] valueForKey:@"objectId"] isEqual:[user valueForKey:@"objectId"]]){
            
            // Enable input fields
            self.ouiDescription.editable = NO;
            
            // Set action hidden
            [self.actionButton setHidden:TRUE];
            [self.done setHidden:TRUE];
            [self.doneLabel setHidden:TRUE];
        }
        
        
    }else{
        [self.actionButton setTitle:@"Add Oui" forState:UIControlStateNormal];
        [self.actionButton setTag:0];
        [self.done setHidden:TRUE];
        [self.doneLabel setHidden:TRUE];
    }
}

- (IBAction)addOuiItem:(id)sender {
    NSLog(@"add");
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
        UIButton *button = (UIButton *)sender;
      
        if([button tag] == 1){
            
            PFQuery *query = [PFQuery queryWithClassName:@"OuiItem"];
            [query whereKey:@"objectId" equalTo:self.ouiItemId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *ouiItem, NSError *error) {
                if (!error) {
              
                    if(self.done.isOn == 1){
                        ouiItem[@"checked"] = [NSNumber numberWithBool:YES];
                    }else{
                        ouiItem[@"checked"] = [NSNumber numberWithBool:NO];
                    }
                    
                    // Update rows
                    [ouiItem setObject:self.ouiItem.text forKey:@"title"];
                    [ouiItem setObject:self.ouiDescription.text forKey:@"descriptionItem"];
                    
                    // Save
                    if([ouiItem saveInBackground]){
                        NSLog(@"%@", self.controller);
                        
                        //[self.navigationController popToRootViewControllerAnimated:true];
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
                    
                } else {
                    // Did not find any ouiItem for the current user
                    NSLog(@"Error: %@", error);
                }
            }];
        }else{
            
            // Create new object
            PFObject *ouiItem = [PFObject objectWithClassName:@"OuiItem"];
            
            // Add for friend
            if([self.friendItem valueForKey:@"objectId"]){
                [ouiItem setObject:self.friendItem forKey:@"user"];
            }else if(self.addedFriend){
                ouiItem[@"email"] = self.addedFriend;
            }else{
                // Get user
                PFUser *user = [PFUser currentUser];
                [ouiItem setObject:user forKey:@"user"];
            }

            // Set title and description
            ouiItem[@"title"] = self.ouiItem.text;
            ouiItem[@"descriptionItem"] = self.ouiDescription.text;
            ouiItem[@"checked"] = [NSNumber numberWithBool:NO];
            
            // Save Oui item
            if([ouiItem saveInBackground]){
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
}

- (IBAction)back:(UIStoryboardSegue *)segue {
   
    AddFriendViewController *friendsController = segue.sourceViewController;
    
    if([friendsController.friendText.text length] > 5){
        
        if([self isValidEmail:friendsController.friendText.text]){
            
            // Set added friend email
            self.addedFriend = friendsController.friendText.text;
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid email address"
                                  message:@"Please enter a valid email address."
                                  delegate:self
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil];
            [alert setTag:1];
            [alert show];
        }
        
    }else{
        // Set addedFriend
        self.friendItem = [[friendsController.friendsArray objectAtIndex:[friendsController.friendPicker selectedRowInComponent:0]]valueForKey:@"user2"];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.ouiDescription.text = @"";
    self.ouiDescription.textColor = [UIColor whiteColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView {
    
    if(self.ouiDescription.text.length == 0) {
        self.ouiDescription.textColor = [UIColor lightGrayColor];
        self.ouiDescription.text = @"Oui description";
        [self.ouiDescription resignFirstResponder];
    }
    
}

// Check if email is valid
-(BOOL) isValidEmail:(NSString *)checkString{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Send user back to addFriendController if email not valid
    if ([alertView tag] == 1){
        
        // Segue to addFriendController
        AddFriendViewController *friendController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
        [self.navigationController pushViewController:friendController animated:YES];
    }
}

@end
