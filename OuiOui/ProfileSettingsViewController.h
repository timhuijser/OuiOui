//
//  ProfileSettingsViewController.h
//  OuiOui
//
//  Created by Tim on 02/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UIViewController

@property UIImage *profilePicture;

- (IBAction)logoutButton:(id)sender;
- (IBAction)takePhotoButton:(id)sender;
- (IBAction)pickPhotoButton:(id)sender;

@end
