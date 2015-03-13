//
//  ShoppingListViewController.m
//  iShoppingList
//
//  Created by Save92 on 11/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "CreateListViewController.h"
#import "ShoppingList.h"

@interface ShoppingListViewController ()

@end

@implementation ShoppingListViewController

@synthesize helloName;

@dynamic User;
@dynamic lists;

static NSString *const kShoppingListCellId = @"ShoppingListId";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"ShoppingList";
        
        NSMutableArray *rightButtons = [NSMutableArray new];
        
        [rightButtons addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onTouchAdd)]];
        [rightButtons addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onTouchEdit)]];
        
        self.navigationItem.rightBarButtonItems = rightButtons;
        
        NSMutableArray *leftButtons = [NSMutableArray new];
        //UIBarButtonItemStyleBordered
        //UIBarButtonSystemItemAction
        [leftButtons addObject:[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonSystemItemCancel target:self action:@selector(logout)]];
        
        self.navigationItem.leftBarButtonItems = leftButtons;
        
    }
    
    return self;
}

- (NSArray *)lists {
    return lists_;
}

- (void)setLists:(NSArray *)lists {
    lists_ = [[NSMutableArray alloc] initWithArray:lists];
}

- (void)onTouchAdd {
    CreateListViewController *viewController = [CreateListViewController new];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onTouchEdit {
    self.tableView.editing = !self.tableView.editing;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShoppingListCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kShoppingListCellId];
    }
    
    ShoppingList *list = [self.lists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = list.name;
    
    return cell;
}

// TODO: faire une vrai gestion des erreurs en fonction des codes retour
// TODO: enlever le token en dur dans l'URL et mettre celui de l'utilisateur courant
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShoppingList *list = (ShoppingList *)[lists_ objectAtIndex:indexPath.row];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/shopping_list/remove.php?token=%@&id=%@", @"161e936338febc2edc95214098db81a1", [NSString stringWithFormat:@"%lu", (unsigned long)list.Id]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
        if (!error) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSString *codeReturn = [jsonDict objectForKey:@"code"];
        
            if ([codeReturn isEqualToString:@"0"]) {
                NSString *resultReturn = [jsonDict objectForKey:@"result"];
            
                // Réussite de la suppression
                if ([resultReturn isEqualToString:@"1"]) {
                    [lists_ removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                }
                // Echec de la suppression
                else if ([resultReturn isEqualToString:@"0"]) {
                
                }
            }
            /*else if ([codeReturn isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Missing required parameter(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
             }*/
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingList *list = [self.lists objectAtIndex:indexPath.row];
    CreateListViewController *viewController = [CreateListViewController new];
    viewController.list = list;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id obj = [lists_ objectAtIndex:sourceIndexPath.row];
    [lists_ removeObjectAtIndex:sourceIndexPath.row];
    [lists_ insertObject:obj atIndex:destinationIndexPath.row];
}

- (void)createListViewControllerDidCreateShoppingList:(ShoppingList *)list {
    [lists_ addObject:list];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)createListViewControllerDidEditShoppingList:(ShoppingList *)list {
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

// TODO: faire une vrai gestion des erreurs en fonction des codes retour
// TODO: enlever le token en dur dans l'URL et mettre celui de l'utilisateur courant
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

    // On test si il y a un nom et on le met dans le message
    if (newUser.firstname != nil) {
        NSMutableString* theString = [NSMutableString string];
        [theString appendFormat:@"Hi !  %@",newUser.firstname];
        self.helloName.text = theString;
    } else {
        self.helloName.text = (NSMutableString *)(@"Hi You!");

    }
    NSLog(@"%@",self.helloName.text);
    // Do any additional setup after loading the view from its nib.

    
    
    // Initialise la source de données de la liste des ShoppingList
    NSMutableArray* lists = [NSMutableArray new];
    
    NSLog(@"--0");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/shopping_list/list.php?token=%@", @"161e936338febc2edc95214098db81a1"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSLog(@"--1");
    if (!error) {
        NSLog(@"--2");
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSString *codeReturn = [jsonDict objectForKey:@"code"];
        NSLog(@"%@", str);
        if ([codeReturn isEqualToString:@"0"]) {
            NSLog(@"--3");
            NSArray *resultReturn = [jsonDict objectForKey:@"result"];
            NSLog(@"%@", resultReturn);
            for (ShoppingList *list in resultReturn) {
                NSLog(@"%@", list);
                [lists_ addObject:list];
            }
            
            self.lists = lists;
        }
        else {
            NSLog(@"--4");
        }
    }
    else {
        NSLog(@"--5");
    }
}

- (BOOL)ifSessionActive{
     NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        NSLog(@"standardUserDefaults Ok!");
        if([standardUserDefaults objectForKey:@"email"] == nil || [standardUserDefaults objectForKey:@"token"] == nil) {
            return false;
        } else
            return true;
    } else {
        return -1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// pour se delog
- (void) logout {
    
    NSLog(@"Logout");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"Done");
    LoginViewController* loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    NSMutableArray *viewControllerArray = [self.navigationController.viewControllers mutableCopy];
    [viewControllerArray removeAllObjects];
    [viewControllerArray addObject:loginView];
    [self.navigationController setViewControllers:viewControllerArray animated:YES];
    
}

@end



