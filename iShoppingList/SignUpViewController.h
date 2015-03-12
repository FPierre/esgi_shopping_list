//
//  SignUpViewController.h
//  iShoppingList
//
//  Created by Save92 on 10/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SignUpViewController : UIViewController {
    @private
    User* user_;
}
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;


- (IBAction)onTouchSubscribe:(id)sender;
- (void) createSessionWithUser:(User* ) newUser;

@end
