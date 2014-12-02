//
//  ProfileSettingsViewController.h
//  OuiOui
//
//  Created by Tim on 02/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property UIImage *profilePicture;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (IBAction)closeSettingsButton:(id)sender;
- (IBAction)logoutButton:(id)sender;
- (IBAction)takePhotoButton:(id)sender;
- (IBAction)pickPhotoButton:(id)sender;

@end
