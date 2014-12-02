//
//  ProfileSettingsViewController.m
//  OuiOui
//
//  Created by Tim on 02/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "Parse/Parse.h"

@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show profilePicture.
    self.profileImageView.layer.masksToBounds = YES;
    [self.profileImageView setImage:self.profilePicture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeSettingsButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButton:(id)sender {
}

- (IBAction)takePhotoButton:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)pickPhotoButton:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    // Dismiss the image selection and hide the picker.
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Generate unique imageName.
    NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@", uniqueString, @".jpg"];
    
    // Convert to JPEG with 50% quality
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:uniqueFileName data:data];
    
    // Save the image to Parse
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            PFObject *userPhoto = [PFObject objectWithClassName:@"profilePicture"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                    [self refreshView];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        
    }];
    
    self.profilePicture = image;
    [self refreshView];
    
}

- (void)refreshView {
    [self viewDidLoad];
    //[self viewWillAppear]; Only use when code in function.
}

@end
