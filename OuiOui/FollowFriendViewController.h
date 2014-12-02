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
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSMutableArray *profilePicData;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) NSString *objectId;
- (IBAction)follow:(id)sender;

@end
