//
//  ProfileSettingViewController.m
//  OuiOui
//
//  Created by Tim on 03/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import "Parse/Parse.h"

@interface ProfileSettingViewController ()

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show profilePicture.
    self.profilePictureImage.layer.masksToBounds = YES;
    [self.profilePictureImage setImage:self.profilePicture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
}

- (IBAction)takePictureButton:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)picPictureButton:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)logoutButton:(id)sender {
    
    // Logout Parse.
    [PFUser logOut];
    
    // Go to login/register view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *obj=[storyboard instantiateViewControllerWithIdentifier:@"startNav"];
    [self presentViewController:obj animated:YES completion:nil];
    
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
