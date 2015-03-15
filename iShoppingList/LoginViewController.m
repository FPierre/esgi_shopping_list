//
//  HomeViewController.m
//  iShoppingList
//
//  Created by Save92 on 19/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"
#import "SignUpViewController.h"
#import "ShoppingListViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtFieldEmail;
@synthesize txtFieldPassword;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self ifSessionActive]) {
        [self logout];
    }
    // Do any additional setup after loading the view from its nib.
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

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLogin:(id)sender {
}

- (IBAction)loginClicked:(id)sender {
        if([self.txtFieldEmail.text isEqualToString:@""] || [self.txtFieldPassword.text isEqualToString:@""] )
        {
            [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
        } else {
            NSLog(@"Login Clicked!");
            // on créer l'url avec les parametres
            NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/account/login.php?email=%@&password=%@", self.txtFieldEmail.text , self.txtFieldPassword.text]];
            NSLog(@"1");
            // On lance la requete
            NSURLRequest* requestLogin=[NSURLRequest requestWithURL:URL];
            NSError* error = nil;
            NSLog(@"2");
            // On recuperer les donnees de retour
            NSData* data = [NSURLConnection sendSynchronousRequest:requestLogin returningResponse:nil error:&error];
            NSLog(@"2,5");
            if(!error) {
                NSLog(@"3");
                // On parse le JSON
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                NSLog(@"4");
                NSLog(@"jsonDict:%@", jsonDict);
                // On recupere le code retour de la requete (code)
                NSString* codeReturn = [jsonDict objectForKey:@"code"];
                if( [codeReturn  isEqualToString:@"0"]) {
                    NSLog(@"Login SUCCESS");
                    // On recupere le result de la requete (result)
                    NSDictionary* result = [jsonDict objectForKey:@"result"];
                    NSLog(@"result:%@", result);
                    //On créer le user avec le result recupere
                    User* newUser = [User new];
                    newUser.email = [result objectForKey:@"email"];
                    newUser.token = [result objectForKey:@"token"];
                    NSLog(@"newUserEmail:%@", newUser.email);
                    NSLog(@"newUserToken:%@", newUser.token);
                    
                    //On enregistre
                    [self createSessionWithUser:newUser];

                    
                    //Redirection si loggué
                    [self alertStatus:@"Logged in Successfully." :@"Login Success!"];
                    ShoppingListViewController* formViewController = [ShoppingListViewController new];
                    [self.navigationController pushViewController:formViewController animated:YES];
                    
                } else {
                    NSLog(@"5");
                    NSString *errorMessage = nil;
                    UITextField *errorField;
                    
                        errorMessage = @"Login Failed!";
                        errorField = self.txtFieldEmail;
                    
                    if (errorMessage) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        [errorField becomeFirstResponder];
                    }
                }
            }
        }
}


// Retourne le chemin du fichier
/*- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}*/

- (IBAction)onTouchSignUp:(id)sender {
    SignUpViewController* formViewController = [SignUpViewController new];
    [self.navigationController pushViewController:formViewController animated:YES];
}

//Permet de creer la session avec le user en parametre
- (void) createSessionWithUser:(User* ) newUser{
    //On enregistre via le UserDefaults
    NSLog(@"email:%@, token:%@, fname:%@, lname:%@", newUser.email, newUser.token, newUser.firstname, newUser.lastname);
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:newUser.email forKey:@"email"];
        NSLog(@"email done : %@", newUser.email);
        [standardUserDefaults setObject:newUser.token forKey:@"token"];
        [standardUserDefaults setObject:newUser.firstname forKey:@"firstname"];
        [standardUserDefaults setObject:newUser.lastname forKey:@"lastname"];
        [standardUserDefaults synchronize];
        NSLog(@"Save ok!");
    }
    
}

// Sers a cacher le clavier en cas de click hors des champs
- (IBAction)backgroundClick:(id)sender {
  //  [txtFieldUsername resignFirstResponder];
  //  [txtFieldPassword resignFirstResponder];
}
@end
