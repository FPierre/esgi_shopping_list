//
//  ProductListViewController.m
//  iShoppingList
//
//  Created by Save92 on 13/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "ProductListViewController.h"
#import "Product.h"
#import "CreateProductViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

@synthesize productTitle;

@dynamic User;
@dynamic products;

static NSString *const kProductCellId = @"ProductId";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Product";
        
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

// Getter
- (NSArray *)products {
    return products_;
}

// Setter
- (void)setProducts:(NSArray *)products {
    products_ = [[NSMutableArray alloc] initWithArray:products];
}

// Bouton "+" d'ajout d'un Product
- (void)onTouchAdd {
    CreateProductViewController *viewController = [CreateProductViewController new];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onTouchEdit {
    self.tableView.editing = !self.tableView.editing;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kProductCellId];
    }
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    cell.textLabel.text = product.name;
    
    return cell;
}

// Suppression d'un Product
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // On recuper le standUserDefaults
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Product *product = (Product *)[products_ objectAtIndex:indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/product/remove.php?token=%@&id=%@", [standardUserDefaults objectForKey:@"token"], product.Id]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if (!error) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSString *codeReturn = [jsonDict objectForKey:@"code"];
            
            // Si pas d'erreur
            if ([codeReturn isEqualToString:@"0"]) {
                NSString *resultReturn = [jsonDict objectForKey:@"result"];
                
                // Réussite de la suppression
                if ([resultReturn isEqualToString:@"1"]) {
                    [products_ removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                }
                // Echec de la suppression
                else if ([resultReturn isEqualToString:@"0"]) {
                    // Pas de gestion d'erreur
                }
            }
            else if ([codeReturn isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Missing required parameter(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([codeReturn isEqualToString:@"4"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Invalid token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([codeReturn isEqualToString:@"5"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Internal server error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([codeReturn isEqualToString:@"6"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Unauthorized action" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }

    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [products_ objectAtIndex:sourceIndexPath.row];
    [products_ removeObjectAtIndex:sourceIndexPath.row];
    [products_ insertObject:obj atIndex:destinationIndexPath.row];
}

- (void)createProductViewControllerDidCreateProduct:(Product *)product {
    [products_ addObject:product];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)createProductViewControllerDidEditProduct:(Product *)product {
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

// TODO: enlever le token en dur dans l'URL et mettre celui de l'utilisateur courant
// TODO: enlever l'Id de la Shopping List en dur dans l'URL
- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    // Initialise la source de données de la liste des Products
    NSMutableArray* products = [NSMutableArray new];
    self.products = products;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/product/list.php?token=%@&id=%@", [standardUserDefaults objectForKey:@"token"], @"400"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (!error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSString *codeReturn = [jsonDict objectForKey:@"code"];
        
        if ([codeReturn isEqualToString:@"0"]) {
            NSArray *resultReturn = [jsonDict objectForKey:@"result"];
            
            for (NSDictionary *o in resultReturn) {
                Product *newProduct = [Product new];
                
                newProduct.Id = [o objectForKey:@"id"];
                newProduct.name = [o objectForKey:@"name"];
                newProduct.quantity = [[o objectForKey:@"quantity"] integerValue];
                newProduct.price = [[o objectForKey:@"price"] doubleValue];
                
                if ([self respondsToSelector:@selector(createProductViewControllerDidCreateProduct:)]) {
                    [self createProductViewControllerDidCreateProduct:newProduct];
                }
            }
        }
        else if ([codeReturn isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Missing required parameter(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([codeReturn isEqualToString:@"4"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Invalid token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([codeReturn isEqualToString:@"5"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Internal server error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([codeReturn isEqualToString:@"6"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Unauthorized action" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
