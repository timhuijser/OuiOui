//
//  ProfileViewController.m
//  OuiOui
//
//  Created by Tim on 26/11/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GPUImage.h"
#import "Parse/Parse.h"

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
    
    // Default value of type to show.
    self.bucketlistItemTypeToShow = @"Uncompleted";
    
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
    // Return the number of rows in the section.
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uncompletedBucketlistCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"uncompletedBucketlistCell"];
    }
    
    if ([self.bucketlistItemTypeToShow isEqualToString:@"Uncompleted"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"Uncompleted title", [NSString stringWithFormat:@"%d", indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", @"Uncompleted Subtitle", [NSString stringWithFormat:@"%d", indexPath.row]];
    } else if ([self.bucketlistItemTypeToShow isEqualToString:@"Completed"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"Completed title", [NSString stringWithFormat:@"%d", indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", @"Completed Subtitle", [NSString stringWithFormat:@"%d", indexPath.row]];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryProfileImageAndSetViews {
    
    PFQuery *profilePictureQuery = [PFQuery queryWithClassName:@"profilePicture"];
    [profilePictureQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [profilePictureQuery orderByDescending:@"createdAt"];
    profilePictureQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [profilePictureQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            self.profileImage.layer.cornerRadius = 65;
            self.profileImage.layer.masksToBounds = YES;
            self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
            self.profileImage.layer.borderWidth = 3.0;
            
            [self.profileImage setImage:[UIImage imageNamed: @"defaultProfile.png"]];
            
            self.blurProfileImage.layer.masksToBounds = YES;
            [self.blurProfileImage setImage:[UIImage imageNamed: @"defaultProfileBackground.png"]];
            
        } else {
            
            PFFile *imageFile = [object objectForKey:@"imageFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                if (!error) {
                    
                    UIImage *profilePicture = [UIImage imageWithData:data];
                    
                    self.profileImage.layer.cornerRadius = 65;
                    self.profileImage.layer.masksToBounds = YES;
                    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
                    self.profileImage.layer.borderWidth = 3.0;
                    
                    [self.profileImage setImage:profilePicture];
                    
                    GPUImageiOSBlurFilter *stillImageFilter2 = [[GPUImageiOSBlurFilter alloc] init];
                    [(GPUImageiOSBlurFilter*)stillImageFilter2 setBlurRadiusInPixels:16.0f];
                    [(GPUImageiOSBlurFilter*)stillImageFilter2 setRangeReductionFactor:0.1f];
                    UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:profilePicture];
                    
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
            self.followersCountLabel.text = [NSString stringWithFormat:@"%d", [self.followersUsersArray count]];
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
            self.followingCountLabel.text = [NSString stringWithFormat:@"%d", [self.followingUsersArray count]];
            
        }
        
    }];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
