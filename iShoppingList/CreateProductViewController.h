//
//  CreateProductViewController.h
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol CreateProductViewControllerDelegate <NSObject>

@optional
- (void)createProductViewControllerDidCreateProduct:(Product *)product;
- (void)createProductViewControllerDidEditProduct:(Product *)product;

@end

@interface CreateProductViewController : UIViewController {
    
@private
    Product *product;
    __weak id<CreateProductViewControllerDelegate> delegate_;

}

@property (strong, nonatomic) Product *product;
@property (weak, nonatomic) id<CreateProductViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextfield;
@property (weak, nonatomic) IBOutlet UITextField *priceTextfield;

- (IBAction)onTouchAdd:(id)sender;

@end
