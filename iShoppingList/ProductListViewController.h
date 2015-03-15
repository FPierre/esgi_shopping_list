//
//  ProductListViewController.h
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CreateProductViewController.h"

//TEST
@protocol ProductListViewControllerDelegate <NSObject>

@end
// FIN TEST

@interface ProductListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CreateProductViewControllerDelegate> {

@private
    NSMutableArray *products_;
    __weak id<ProductListViewControllerDelegate> delegate_; // TEST

}

@property (nonatomic, strong) User* User;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;

@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id<ProductListViewControllerDelegate> delegate; // TEST

@end
