//
//  CreateProductViewController.m
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "CreateProductViewController.h"

@interface CreateProductViewController ()

@end

@implementation CreateProductViewController

@synthesize products = product_;
@synthesize delegate = delegate_;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"New Product";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.products) {
        self.nameTextField.text = self.products.name;
        NSString* price = [NSString stringWithFormat:@"%f", self.products.price];
        self.priceTextField.text = price;
        NSString* quantity = [NSString stringWithFormat:@"%lu", (unsigned long)self.products.quantity];
        self.quantityTextField.text = quantity;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTouchAdd:(id)sender {
    if (!self.products) {
        //@TODO voir comment recuperer le token et l'id de la liste
        
        /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/product/create.php?token=%@&shopping_list_id=%@&name=%@&quantity=%@&price=%@", self.User.token, shoppingListId, self.products.name, self.products.quantity, self.products.price]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if (!error) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSString *codeReturn = [jsonDict objectForKey:@"code"];
            
            if ([codeReturn isEqualToString:@"0"]) {
                Product *newProduct = [Product new];
                NSDictionary *result = [jsonDict objectForKey:@"result"];
                
                newProduct.name = [result objectForKey:@"name"];
                
                if ([self.delegate respondsToSelector:@selector(createProductViewControllerDidCreateSProductList:)]) {
                    NSLog(@"1");
                    [self.delegate createProductViewControllerDidCreateProduct:newProduct];
                }
            }
        }*/
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
