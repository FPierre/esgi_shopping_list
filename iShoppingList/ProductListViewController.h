//
//  ProductListViewController.h
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProductListViewController: UIViewController {

@private
    NSMutableArray *products_;

}


@property (nonatomic, strong) User* User; // User connecte
@property (weak, nonatomic) IBOutlet UILabel *productTitle;

@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
