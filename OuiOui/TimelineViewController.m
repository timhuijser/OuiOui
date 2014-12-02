//
//  TimelineViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "TimelineViewController.h"
#import "Parse/Parse.h"
#import "OuiItemViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

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

    // Set segment control
    segmentControl.selectedSegmentIndex = 0;
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

-(IBAction)segmentButton:(id)sender{
    
    // Get completed Oui's
    if(segmentControl.selectedSegmentIndex == 0){
        [self retrieveData:@"false"];
    }else{
        [self retrieveData:@"true"];
    }
}

-(void)retrieveData:(NSString *)inputType{
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"OuiItem"];
    [ouiItems whereKey:@"user" equalTo:user];
    
    // Check if type is true
    if([inputType isEqualToString:@"true"]){
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:YES]];
    }else{
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:NO]];
    }
    
    [ouiItems orderByDescending:@"createdAt"];
    ouiItems.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            // Set objects in ouItemsDB array
            ouiItemsDB = [[NSMutableArray alloc] initWithArray:objects];
            
            // Reload tableview
            [self.tableView reloadData];
        }else{
            NSLog(@"error");
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section
    return ouiItemsDB.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set cell identifier
    static NSString *cellIdentifier = @"ouiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Set array in temp object
    PFObject *tempObject = [ouiItemsDB objectAtIndex:indexPath.row];
    
    // Set text label title
    cell.textLabel.text = [tempObject objectForKey:@"title"];
    
    return cell;
}

// Delete item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *tempObject = [ouiItemsDB objectAtIndex:indexPath.row];

    PFQuery *query = [PFQuery queryWithClassName:@"OuiItem"];
    [query whereKey:@"objectId" equalTo:tempObject.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *ouiItem, NSError *error) {
        if (!error) {

            // Delete
            if([ouiItem deleteInBackground]){
                // Get back
                if([[ouiItem objectForKey:@"checked"] isEqual:[NSNumber numberWithBool:NO]]){
                    [self retrieveData:@"false"];
                }else{
                    [self retrieveData:@"true"];
                }
                
            }else{
                // Can't save new Oui item
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Not deleted"
                                      message:@"We could not delete your Oui item, try again."
                                      delegate:nil
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil];
                
                [alert show];
            }
            
        } else {
            // Did not find any ouiItem for the current user
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"showDetail"]){
        
        // Get selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Get object out of ouiItems
        NSArray *selectedItem = [ouiItemsDB objectAtIndex:indexPath.row];
        
        OuiItemViewController *destViewController = segue.destinationViewController;
        destViewController.item = selectedItem;
    }
}

@end
