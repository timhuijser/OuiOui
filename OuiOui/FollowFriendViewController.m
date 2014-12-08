//
//  FollowFriendViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 02-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "FollowFriendViewController.h"
#import "Parse/Parse.h"

@interface FollowFriendViewController ()

@end

@implementation FollowFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Style navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // Set navigation controller to only back button
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"OuiOui";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.objectId = [self.item valueForKey:@"objectId"];
    
    // Set profile pic
    PFQuery *profilePictureQuery = [PFQuery queryWithClassName:@"profilePicture"];
    [profilePictureQuery whereKey:@"user" equalTo:self.item];
    
    [profilePictureQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [self.profilePic setImage:[UIImage imageNamed: @"defaultProfileGrey"]];
        }else{
            PFFile *imageFile = [object objectForKey:@"imageFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (!error) {
                    [self.profilePic setImage:[UIImage imageWithData:data]];
                }
            }];
        }
    }];
    // Get current user
    PFUser *user = [PFUser currentUser];

    // Query for follow
    PFQuery *follow = [PFQuery queryWithClassName:@"Follow"];
    
    [follow whereKey:@"user1" equalTo:user];
    
    [follow findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            self.followData = [[NSMutableArray alloc] initWithArray:objects];
            
            // Check if user already follows this user
            if([[[self.followData valueForKey:@"user2"] valueForKey:@"objectId"] containsObject:[self.item valueForKey:@"objectId"]]){
                [self.followButton setTag:1];
                [self.followButton setTitle:@"Stop following" forState:UIControlStateNormal];
                [self.messageLabel setHidden:TRUE];
            }
        }
    }];
    
    // Check if selected user is current user
    if([[user valueForKey:@"objectId"] isEqualToString:[self.item valueForKey:@"objectId"]]){
        [self.followButton setHidden:TRUE];
        [self.messageLabel setHidden:FALSE];
        self.messageLabel.text = @"You can't follow yourself";
    }else{
        [self.followButton setTag:0];
        [self.messageLabel setHidden:TRUE];
    }
    
    self.name.text = [self.item valueForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)follow:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    // Check wich action is needed
    if([button tag] == 0){
        
        // Create new object
        PFObject *follow = [PFObject objectWithClassName:@"Follow"];
    
        // Set user1 (yourself)
        PFUser *user = [PFUser currentUser];
        [follow setObject:user forKey:@"user1"];
    
        follow[@"user2"] = self.item;
        follow[@"name"] = [self.item valueForKey:@"name"];
    
        // Save follow
        if([follow saveInBackground]){
            // Return to users
            [self.navigationController popToRootViewControllerAnimated:true];
        }else{
            // Error
            UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Something went wrong, try again."
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        
            [alert show];
        }
    }else{
        // Get current user
        PFUser *user = [PFUser currentUser];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
        [query whereKey:@"user1" equalTo:user];
        [query whereKey:@"user2" equalTo:self.item];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *ouiItem, NSError *error) {
            if (!error) {
                
                // Delete
                if([ouiItem deleteInBackground]){
                    // Return to users
                    [self.navigationController popToRootViewControllerAnimated:true];
                }
            }
        }];
    }
}
@end
