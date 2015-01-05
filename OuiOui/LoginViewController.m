//
//  LoginViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 20-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "LoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // Set navigation controller to only back button
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.topItem.title = @" ";
    
    // Set placeholdertext color
    UIColor *color = [UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0];
    
    // Style input fields
    self.email.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.email.layer.borderWidth = 2.0;
    UIView *emailPaddingInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.email.leftView = emailPaddingInput;
    self.email.leftViewMode = UITextFieldViewModeAlways;
    self.email.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email address" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.password.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.password.layer.borderWidth = 2.0;
    UIView *passwordPaddingInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.password.leftView = passwordPaddingInput;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

- (IBAction)loginButton:(id)sender {
    
    NSString *username = [self.email text];
    NSString *password = [self.password text];
    
    if ([username length] < 4 || [password length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tab" bundle:nil];
                UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"tab"];
                self.navigationController.navigationBarHidden=YES;
                [self.navigationController pushViewController:obj animated:YES];
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    
}

- (IBAction)loginFacebookButton:(id)sender {
    
    NSArray *permissions = @[@"email"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Something went wrong, try to login again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        } else if (user.isNew) {
            
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSString *name = userData[@"name"];
                    NSString *email = userData[@"email"];
                    NSString *facebookID = userData[@"id"];
                    
                    user.email = email;
                    user[@"name"] = name;
                    user[@"facebookID"] = facebookID;
                    [user save];
                    
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
                    
                    // Run network request asynchronously
                    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        if (connectionError == nil && data != nil) {
                            
                            // Generate unique imageName.
                            NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
                            NSString *uniqueFileName = [NSString stringWithFormat:@"%@%@", uniqueString, @".jpg"];
                            
                            // Convert to JPEG with 50% quality
                            NSData *profileImageData = UIImageJPEGRepresentation([UIImage imageWithData:data], 0.5f);
                            PFFile *imageFile = [PFFile fileWithName:uniqueFileName data:profileImageData];
                            
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
                                            //[self refreshView];
                                        }
                                        else{
                                            // Error
                                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tab" bundle:nil];
            UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"tab"];
            self.navigationController.navigationBarHidden=YES;
            [self.navigationController pushViewController:obj animated:YES];
            
        } else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tab" bundle:nil];
            UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"tab"];
            self.navigationController.navigationBarHidden=YES;
            [self.navigationController pushViewController:obj animated:YES];
            
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

@end
