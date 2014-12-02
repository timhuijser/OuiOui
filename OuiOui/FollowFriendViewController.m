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
    PFQuery *profilePic = [PFQuery queryWithClassName:@"profilePicture"];
    [profilePic whereKey:@"user" equalTo:self.item];
    
    profilePic.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [profilePic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            self.profilePicData = [[NSMutableArray alloc] initWithArray:objects];
             NSLog(@"%@", self.profilePicData);
        }
    }];
    
    self.name.text = [self.item valueForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)follow:(id)sender {
    NSLog(@"%@", self.objectId);
}
@end
