//
//  RegisterViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 20-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@end
