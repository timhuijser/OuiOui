//
//  ProfileViewController.m
//  OuiOui
//
//  Created by Tim on 26/11/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GPUImage.h"
#import "Parse/Parse.h"
#import "OuiItemViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    
    // Get profile image from Parse and show it in the views.
    [self queryProfileImageAndSetViews];
    
    // Get number of followers from Parse.
    [self queryFollowers];
    
    // Get number of followers from Parse.
    [self queryFollowing];
    
    // Retrieve uncompleted OuiItem data from Parse as default behaviour.
    [self retrieveOuiItemData:@"Uncompleted"];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.nameLabel.text = [[PFUser currentUser] valueForKey:@"name"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section
    return self.ouiItemsDB.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bucketlistCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bucketlistCell"];
    }
    
    // Set array in temp object
    PFObject *tempObject = [self.ouiItemsDB objectAtIndex:indexPath.row];
    
    // Set text label title
    cell.textLabel.text = [tempObject objectForKey:@"title"];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Light status bar.
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)queryProfileImageAndSetViews {
    
    PFQuery *profilePictureQuery = [PFQuery queryWithClassName:@"profilePicture"];
    [profilePictureQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [profilePictureQuery orderByDescending:@"createdAt"];
    profilePictureQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [profilePictureQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            self.profileImage.layer.cornerRadius = 50;
            self.profileImage.layer.masksToBounds = YES;
            self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
            self.profileImage.layer.borderWidth = 3.0;
            
            self.profilePicture = [UIImage imageNamed: @"defaultProfileGrey"];
            
            [self.profileImage setImage:[UIImage imageNamed: @"defaultProfileGrey"]];
            
            self.blurProfileImage.layer.masksToBounds = YES;
            [self.blurProfileImage setImage:[UIImage imageNamed: @"background.png"]];
            
        } else {
            PFFile *imageFile = [object objectForKey:@"imageFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (!error) {
                    self.profilePicture = [UIImage imageWithData:data];
                    
                    self.profileImage.layer.cornerRadius = 50;
                    self.profileImage.layer.masksToBounds = YES;
                    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
                    self.profileImage.layer.borderWidth = 3.0;
                    
                    [self.profileImage setImage:self.profilePicture];
                    
                    GPUImageiOSBlurFilter *stillImageFilter2 = [[GPUImageiOSBlurFilter alloc] init];
                    [(GPUImageiOSBlurFilter*)stillImageFilter2 setBlurRadiusInPixels:16.0f];
                    [(GPUImageiOSBlurFilter*)stillImageFilter2 setRangeReductionFactor:0.1f];
                    UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:self.profilePicture];
                    
                    self.blurProfileImage.layer.masksToBounds = YES;
                    [self.blurProfileImage setImage:quickFilteredImage];
                    
                }
            }];
            
        }
    }];
    
}

- (void)queryFollowers {
    
    PFQuery *followersQuery = [PFQuery queryWithClassName:@"Follow"];
    [followersQuery whereKey:@"user2" equalTo:[PFUser currentUser]];
    followersQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [followersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            self.followersUsersArray = (NSMutableArray *)objects;
            self.followersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.followersUsersArray count]];
        }
        
    }];
    
}

- (void)queryFollowing {
    
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Follow"];
    [followingQuery whereKey:@"user1" equalTo:[PFUser currentUser]];
    followingQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [followingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            self.followingUsersArray = (NSMutableArray *)objects;
            self.followingCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.followingUsersArray count]];
            
        }
        
    }];
    
}

-(void)retrieveOuiItemData:(NSString *)inputType{
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"OuiItem"];
    [ouiItems whereKey:@"user" equalTo:user];
    
    // Check if type is true
    if([inputType isEqualToString:@"Uncompleted"]){
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:NO]];
    }else{
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:YES]];
    }
    
    [ouiItems orderByDescending:@"createdAt"];
    ouiItems.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            // Set objects in ouItemsDB array
            self.ouiItemsDB = [[NSMutableArray alloc] initWithArray:objects];
            
            self.ouiItemCountLabel.text = [NSString stringWithFormat: @"%ld", (long)self.ouiItemsDB.count];
            // Reload tableview
            [self.bucketlistItemTableView reloadData];
        }else{
            NSLog(@"error");
        }
    }];
}

- (IBAction)bucketListSegmentControl:(id)sender {
    
    if (self.bucketlistSegmentControlOutlet.selectedSegmentIndex == 0) {
        [self retrieveOuiItemData:@"Uncompleted"];
    } else if (self.bucketlistSegmentControlOutlet.selectedSegmentIndex == 1) {
        [self retrieveOuiItemData:@"Completed"];
    }
    
    [self.bucketlistItemTableView reloadData];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"profileToProfileSettings"]) {
        
        ProfileSettingViewController *profileSettingController = [segue destinationViewController];
        profileSettingController.profilePicture = self.profilePicture;
        
    }
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        // Get selected row
        NSIndexPath *indexPath = [self.bucketlistItemTableView indexPathForSelectedRow];
        
        // Get object out of ouiItems
        NSArray *selectedItem = [self.ouiItemsDB objectAtIndex:indexPath.row];
        
        OuiItemViewController *destController = [segue destinationViewController];
        destController.item = selectedItem;
        destController.controller = @"Profile";
    }
}

- (IBAction)back:(UIStoryboardSegue *)segue {
}


@end
