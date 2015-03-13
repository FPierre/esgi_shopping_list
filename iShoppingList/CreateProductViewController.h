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
- (void)createProductViewControllerDidCreateProduct:(Product *)products;
- (void)createProductViewControllerDidEditProduct:(Product *)products;

@end

@interface CreateProductViewController : UIViewController {
    @private
    Product *product;
    __weak id<CreateProductViewControllerDelegate> delegate_;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) Product *products;
@property (weak, nonatomic) id<CreateProductViewControllerDelegate> delegate;

- (IBAction)onTouchAdd:(id)sender;

@end
