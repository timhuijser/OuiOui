//
//  ProfileViewController.h
//  OuiOui
//
//  Created by Tim on 26/11/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *blurProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ouiItemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *bucketlistItemTableView;
- (IBAction)bucketListSegmentControl:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bucketlistSegmentControlOutlet;

@property PFUser *userToShow;
@property NSMutableArray *ouiItemsDB;
@property UIImage *profilePicture;

@property NSMutableArray *followingUsersArray;
@property NSMutableArray *followersUsersArray;

@end
