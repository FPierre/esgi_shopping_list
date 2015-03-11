//
//  CreateListViewController.h
//  iShoppingList
//
//  Created by Pierre Flauder on 10/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingList.h"

@protocol CreateListViewControllerDelegate <NSObject>

@optional
- (void)createListViewControllerDidCreateShoppingList:(ShoppingList *)list;
- (void)createListViewControllerDidEditShoppingList:(ShoppingList *)list;

@end

@interface CreateListViewController : UIViewController {

@private
    ShoppingList *list;
    __weak id<CreateListViewControllerDelegate> delegate_;

}

@property (strong, nonatomic) ShoppingList *list;
@property (weak, nonatomic) id<CreateListViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;

- (IBAction)onTouchAdd:(id)sender;

@end
