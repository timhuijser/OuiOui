//
//  NewOuiItemViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOuiItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ouiItem;
@property (weak, nonatomic) IBOutlet UITextView *ouiDescription;
- (IBAction)addOuiItem:(id)sender;

@end
