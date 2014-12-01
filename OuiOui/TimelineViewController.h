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

-(IBAction)segmentButton:(id)sender;


@end
