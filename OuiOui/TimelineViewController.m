//
//  TimelineViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 25-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "TimelineViewController.h"
#import "Parse/Parse.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // Set navigation controller to only back button
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.title = @"OuiOui";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

-(void)viewDidAppear:(BOOL)animated{
     [self.tableView reloadData];
    self.navigationItem.title = @"OuiOui";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"OuiItem"];
    [ouiItems whereKey:@"user" equalTo:user];
    [ouiItems orderByDescending:@"createdAt"];
    ouiItems.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            // Set objects in ouItemsDB array
            ouiItemsDB = [[NSArray alloc] initWithArray:objects];
            // Herlaadt tableview
            [self.tableView reloadData];
        }else{
            NSLog(@"error");
        }
    }];
}

#pragma mark - Table view data source

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

@end
