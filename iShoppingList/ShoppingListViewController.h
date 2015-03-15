//
//  ShoppingListViewController.h
//  iShoppingList
//
//  Created by Save92 on 11/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CreateListViewController.h"

@interface ShoppingListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CreateListViewControllerDelegate> {
    
@private
    NSMutableArray *lists_;
    //User *myUser_;
    NSString *token;
    
}

//@property (nonatomic, strong) User* myUser;
@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *helloName;
@property (weak, nonatomic) IBOutlet UILabel *userToken;


@property (strong, nonatomic) NSArray *lists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
