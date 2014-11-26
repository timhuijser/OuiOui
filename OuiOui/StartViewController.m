//
//  StartViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 20-11-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // FB user
    if ([PFUser currentUser]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tab" bundle:nil];
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"tab"];
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
