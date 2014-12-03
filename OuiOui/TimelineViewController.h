//
//  TimelineViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseExampleCell.h"

@interface TimelineViewController : UITableViewController <UITableViewDelegate>{
    NSMutableArray *ouiItemsDB;
    IBOutlet UISegmentedControl *segmentControl;
}

@property (strong) NSMutableArray *followersArray;
@property (strong) NSMutableArray *users;

-(IBAction)segmentButton:(id)sender;


@end
