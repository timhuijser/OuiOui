//
//  TimelineViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "SearchViewController.h"
#import "Parse/Parse.h"
#import "FollowFriendViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set colors
    UIColor *titleColor = [UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    // Style navigation bar
    self.navigationItem.title = @"OuiOui";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};

    // During startup (-viewDidLoad or in storyboard) do:
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

-(void)viewDidAppear:(BOOL)animated{
    // Set colors
    UIColor *titleColor = [UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    // Style navigation bar
    self.navigationItem.title = @"OuiOui";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};

    
    // Get data
    [self retrieveData:@"false"];
}
-(void)retrieveData:(NSString *)inputType{
    
    // Get al users
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            ouiUsers = [[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section
    return ouiUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set cell identifier
    static NSString *cellIdentifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Set array in temp object
    PFObject *tempObject = [ouiUsers objectAtIndex:indexPath.row];
    
    // Set text label title
    cell.textLabel.text = [tempObject objectForKey:@"name"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"followFriend"]){
        
        // Get selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Get object out of ouiItems
        NSArray *selectedItem = [ouiUsers objectAtIndex:indexPath.row];
        
        FollowFriendViewController *destViewController = segue.destinationViewController;
        destViewController.item = selectedItem;
    }
}

@end
