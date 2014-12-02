//
//  NewOuiItemViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OuiItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ouiItem;
@property (weak, nonatomic) IBOutlet UITextView *ouiDescription;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (retain, nonatomic) NSString *addedFriend;
@property (weak, nonatomic) NSString *invitedFriend;
@property (weak, nonatomic) NSString *ouiItemId;
@property (strong) NSObject *item;
@property (weak, nonatomic) IBOutlet UISwitch *done;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

- (IBAction)addOuiItem:(id)sender;

@end
