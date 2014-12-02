//
//  FollowFriendViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 02-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowFriendViewController : UIViewController

@property (strong) NSObject *item;
@property (strong, nonatomic) NSMutableArray *profilePicData;
@property (strong, nonatomic) NSMutableArray *followData;
@property (weak, nonatomic) NSString *objectId;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

- (IBAction)follow:(id)sender;

@end
