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

@interface SearchViewController : UITableViewController <UITableViewDelegate, UISearchBarDelegate>{
    NSMutableArray *ouiUsers;
    NSArray *results;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
