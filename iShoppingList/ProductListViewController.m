//
//  ProductListViewController.m
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "ProductListViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "CreateProductViewController.h"
#import "Product.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

@synthesize productTitle;

@dynamic User;
@dynamic products;

static NSString *const kProductCellId = @"ProductId";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Products List";
        
        NSMutableArray *rightButtons = [NSMutableArray new];
        
        [rightButtons addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onTouchAdd)]];
        [rightButtons addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onTouchEdit)]];
        
        self.navigationItem.rightBarButtonItems = rightButtons;
        
        NSMutableArray *leftButtons = [NSMutableArray new];
        [leftButtons addObject:[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonSystemItemCancel target:self action:@selector(logout)]];
        
        self.navigationItem.leftBarButtonItems = leftButtons;
        
    }
    
    return self;
}


- (NSArray *)products {
    return products_;
}

- (void)setProducts:(NSArray *)products {
    products_ = [[NSMutableArray alloc] initWithArray:products];
}

- (void)onTouchAdd {
    CreateProductViewController *viewController = [CreateProductViewController new];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onTouchEdit {
    self.productsTableView.editing = !self.productsTableView.editing;
}

- (NSInteger)productsTableView:(UITableView *)productsTableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (UITableViewCell *)productsTableView:(UITableView *)productsTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [productsTableView dequeueReusableCellWithIdentifier:kProductCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kProductCellId];
    }
    
    Product *products = [self.products objectAtIndex:indexPath.row];
    
    cell.textLabel.text = products.name;
    
    return cell;
}

- (void)productsTableView:(UITableView *)productsTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [products_ removeObjectAtIndex:indexPath.row];
        [self.productsTableView reloadData];
    }
}

- (void)productsTableView:(UITableView *)productsTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = [self.products objectAtIndex:indexPath.row];
    CreateProductViewController *viewController = [CreateProductViewController new];
    viewController.products = product;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)productsTableView:(UITableView *)productsTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [products_ objectAtIndex:sourceIndexPath.row];
    [products_ removeObjectAtIndex:sourceIndexPath.row];
    [products_ insertObject:obj atIndex:destinationIndexPath.row];
}

- (void)createProductViewControllerDidCreateProduct:(Product *)products {
    NSLog(@"2");
    [products_ addObject:products];
    NSLog(@"3");
    NSLog(@"%@", products_);
    [self.productsTableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)createProductViewControllerDidEditProduct:(Product *)product {
    [self.productsTableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialise la source de données de la liste des ShoppingList
    NSMutableArray* products = [NSMutableArray new];
    self.products = products;
    
    // On recuper le standUserDefaults
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    // On initialise les vatiables pour recuperer les valeurs du standarUserDefaults
    NSString *valEmail = @"0";
    NSString *valToken = @"0";
    NSString *valFirstName = @"0";
    NSString *valLastName = @"0";
    
    
    // On test si il a bien ete cree
    if (standardUserDefaults) {
        // On recupere les donnees
        NSLog(@"standardUserDefaults Ok!");
        valEmail = [standardUserDefaults objectForKey:@"email"];
        valToken  = [standardUserDefaults objectForKey:@"token"];
        valFirstName = [standardUserDefaults objectForKey:@"firstname"];
        valLastName  = [standardUserDefaults objectForKey:@"lastname"];
    }
    // On verifie que le token est bien present sinon erreur
    if ([valToken isEqualToString:@"0"]) {
        // ALERT ERROR probleme lors de l'authentification
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Erreur lors de la recuperation du token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    // On cree un nouvel User et on lui copy les donnees
    User * newUser = [User new];
    newUser = [newUser createUserWithEmail:valEmail withToken:valToken withFirstname:valFirstName withLastname:valLastName];
    NSLog(@"newUser.email:%@",newUser.email);
    NSLog(@"newUser.token : %@",newUser.token);
    NSLog(@"newUser.firstname : %@",newUser.firstname);
    NSLog(@"newUser.lastname : %@",newUser.lastname);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
