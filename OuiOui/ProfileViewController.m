//
//  ProfileViewController.m
//  OuiOui
//
//  Created by Tim on 26/11/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UIViewController *obj=[storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:obj animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
