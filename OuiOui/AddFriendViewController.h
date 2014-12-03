//
//  AddFriendViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 01-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray *friendsArray;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIPickerView *friendPicker;
@property (weak, nonatomic) IBOutlet UITextField *friendText;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;


@end
