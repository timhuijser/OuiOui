//
//  ProfileOverviewViewController.h
//  OuiOui
//
//  Created by Tim on 01/12/14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileOverviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageBlurredImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ouiItemNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumberLabel;

@end
