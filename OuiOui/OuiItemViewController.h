//
//  NewOuiItemViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OuiItemViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSString *addedFriend;
@property (strong, nonatomic) NSString *invitedFriend;
@property (strong, nonatomic) NSString *ouiItemId;
@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;

@property (strong, nonatomic) CLLocationManager *locationManager;


@property (strong) NSObject *item;
@property (strong) NSObject *friendItem;


@property (weak, nonatomic) IBOutlet UITextField *ouiItem;
@property (weak, nonatomic) IBOutlet UITextView *ouiDescription;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UISwitch *done;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

- (IBAction)addOuiItem:(id)sender;

@end
