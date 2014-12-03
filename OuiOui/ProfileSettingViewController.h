//
//  ProfileSettingViewController.h
//  OuiOui
//
//  Created by Tim on 03/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)backButton:(id)sender;
- (IBAction)takePictureButton:(id)sender;
- (IBAction)picPictureButton:(id)sender;
- (IBAction)logoutButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;

@property UIImage *profilePicture;

@end
