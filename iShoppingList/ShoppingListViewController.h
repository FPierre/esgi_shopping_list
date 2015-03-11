//
//  ShoppingListViewController.h
//  iShoppingList
//
//  Created by Save92 on 11/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ShoppingListViewController : UIViewController
@property (nonatomic, strong) User* User;
@property (weak, nonatomic) IBOutlet UILabel *helloName;
@property (weak, nonatomic) IBOutlet UILabel *userToken;

@end
