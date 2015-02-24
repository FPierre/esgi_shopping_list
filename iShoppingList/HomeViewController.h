//
//  HomeViewController.h
//  iShoppingList
//
//  Created by Save92 on 19/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
- (IBAction)loginClicked:(id)sender;
- (IBAction)signUpClicked:(id)sender;
- (IBAction)backgroundClick:(id)sender;

@end
