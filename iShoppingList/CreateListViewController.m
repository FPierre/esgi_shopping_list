//
//  CreateListViewController.m
//  iShoppingList
//
//  Created by Pierre Flauder on 10/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "CreateListViewController.h"

@interface CreateListViewController ()

@end

@implementation CreateListViewController

@synthesize list = list_;
@synthesize delegate = delegate_;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"New Shopping List";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.list) {
        self.nameTextfield.text = self.list.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// TODO: remplacer le token User en dur dans l'URL
- (IBAction)onTouchAdd:(id)sender {
    // recuperation du token du user
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    // Ajout d'une ShoppingList
    if (!self.list) {
        // On cree l'URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/shopping_list/create.php?token=%@&name=%@", [standardUserDefaults objectForKey:@"token"], self.nameTextfield.text]];
        // On lance la requete
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        //Test si pas d'erreur
        if (!error) {
            //Parse le JSON
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSString *codeReturn = [jsonDict objectForKey:@"code"];
            // TEst si code retour Ok
            if ([codeReturn isEqualToString:@"0"]) {
                //Enregistrement de la list
                ShoppingList *newList = [ShoppingList new];
                NSDictionary *result = [jsonDict objectForKey:@"result"];
                
                newList.Id = [result objectForKey:@"id"];
                newList.name = [result objectForKey:@"name"];

                if ([self.delegate respondsToSelector:@selector(createListViewControllerDidCreateShoppingList:)]) {
                    [self.delegate createListViewControllerDidCreateShoppingList:newList];
                }
            }
            // Cas d'erreur de retour de l'API
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
    // Modification d'une ShoppingList
    else {
        self.list.name = self.nameTextfield.text;
     
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/shopping_list/edit.php?token=%@&id=%@&name=%@", [standardUserDefaults objectForKey:@"token"], self.list.Id, self.nameTextfield.text]];
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
                
                // Réussite de la modification
                if ([resultReturn isEqualToString:@"1"]) {
                    if ([self.delegate respondsToSelector:@selector(createListViewControllerDidEditShoppingList:)]) {
                        [self.delegate createListViewControllerDidEditShoppingList:self.list];
                    }
                }
                // Echec de la modification
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

@end
