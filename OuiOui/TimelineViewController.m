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
    
    // Set navigation item
    [self.navigationItem setTitle:@"Oui's"];

    // During startup (-viewDidLoad or in storyboard) do:
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
  
    [self retrieveFollowers];
    
    // Set segment control
    segmentControl.selectedSegmentIndex = 0;
    
    // Get data
    [self retrieveData:@"false"];
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
    
    // Set segment control
    segmentControl.selectedSegmentIndex = 0;
    
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

-(void)retrieveFollowers{
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get followers query
    PFQuery *followers = [PFQuery queryWithClassName:@"Follow"];
    [followers whereKey:@"user1" equalTo:user];
   
    [followers orderByDescending:@"createdAt"];
    
    NSArray *objects = [followers findObjects];
    
    if (objects){
        self.followersArray = [[NSMutableArray alloc] initWithArray:objects];
            
        // Set object id's in array
        NSMutableArray *rawData=[NSMutableArray new];
        [rawData addObject:user];
        for (int i = 0; i < [self.followersArray count]; i++){
            [rawData addObject:[[self.followersArray objectAtIndex:i] valueForKey:@"user2"]];
        }
        self.users = rawData;
    }else{
        NSLog(@"No followers");
    }
}


-(void)retrieveData:(NSString *)inputType{

    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"OuiItem"];

    if(self.followersArray){
        [ouiItems whereKey:@"user" containedIn:self.users];
    }else{
        [ouiItems whereKey:@"user" equalTo:user];
    }
    
    // Check if type is true
    if([inputType isEqualToString:@"true"]){
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:YES]];
    }else{
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:NO]];
    }
    
    [ouiItems orderByDescending:@"createdAt"];
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            // Set objects in ouItemsDB array
            self.ouiItemsDB = [[NSMutableArray alloc] initWithArray:objects];
            
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
    return self.ouiItemsDB.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set cell identifier
    static NSString *cellIdentifier = @"ouiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Set array in temp object
    PFObject *tempObject = [self.ouiItemsDB objectAtIndex:indexPath.row];
    
    // For loop through users array
    for (int i = 0; i < [self.users count]; i++){
       
        if([[[tempObject objectForKey:@"user"] valueForKey:@"objectId"] isEqual:[[self.users objectAtIndex:i] valueForKey:@"objectId"]]){
            
            // Set subtitle
            ///PFUser * toUser = [friends[0] objectForKey:@"toUser"];
            
            PFUser *toUser = [self.users objectAtIndex:i];
           
            // Get ouiItems query
            PFQuery *userData = [PFUser query];
            [userData whereKey:@"objectId" equalTo:toUser.objectId];
            [userData findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects){
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [objects valueForKey:@"name"]];
                }else{
                    NSLog(@"error");
                }
            }];
            
            // Show defaultProfile image.
            UIImage *profilePicture = [UIImage imageNamed: @"defaultProfileGrey.png"];
            cell.imageView.layer.cornerRadius = 22.0f;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.image = profilePicture;
            
            // Get profile picture from follower
            PFQuery *followersPictures = [PFQuery queryWithClassName:@"profilePicture"];
            [followersPictures whereKey:@"user" equalTo:[self.users objectAtIndex:i]];
            [followersPictures getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
                if(object){
                    
                    PFFile *imageFile = [object objectForKey:@"imageFile"];
                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        
                        if (!error) {
                            cell.imageView.image = [UIImage imageWithData:data];
                        }
                    }];
                }else{
                    NSLog(@"Error, %@", error);
                }
            }];
        }
    }
    
    // Set text label title
    cell.textLabel.text = [tempObject objectForKey:@"title"];
    
    return cell;
}

// Delete item
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    PFObject *tempObject = [self.ouiItemsDB objectAtIndex:indexPath.row];
 
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Check if user is owner of Oui item
    if([[[tempObject valueForKey:@"user"] valueForKey:@"objectId"] isEqual:[user valueForKey:@"objectId"]]){
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
    }else{
        // Can't save new Oui item
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No no!"
                              message:@"You can't delete Oui's from others!"
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"showDetail"]){
        
        // Get selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Get object out of ouiItems
        NSArray *selectedItem = [self.ouiItemsDB objectAtIndex:indexPath.row];
        
        OuiItemViewController *destViewController = segue.destinationViewController;
        destViewController.item = selectedItem;
    }
}

@end
