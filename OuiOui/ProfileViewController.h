//
//  ProfileViewController.h
//  OuiOui
//
//  Created by Tim on 26/11/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *blurProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ouiItemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *bucketlistItemTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bucketlistSegmentControlOutlet;

@property PFUser *userToShow;

@property UIImage *profilePicture;

@property NSString *bucketlistItemTypeToShow;
@property NSMutableArray *followingUsersArray;
@property NSMutableArray *followersUsersArray;

@end
