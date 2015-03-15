//
//  SignUpViewController.m
//  iShoppingList
//
//  Created by Save92 on 10/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "SignUpViewController.h"
#import "ShoppingListViewController.h"
#import "User.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)onTouchSubscribe:(id)sender {
    bool isValid = self.isFormDataValid;
    if (isValid == YES) {
                if(self.lastname.text != nil) {
            // on créer l'url avec les parametres
            NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/account/subscribe.php?email=%@&firstname=%@&password=%@&lastname=%@", self.email.text , self.firstname.text,self.password.text, self.lastname.text]];
            //On lance la requete
            NSURLRequest* requestSubscribe=[NSURLRequest requestWithURL:URL];
            NSError* error = nil;
            // On recupere les donnes
            NSData* data = [NSURLConnection sendSynchronousRequest:requestSubscribe returningResponse:nil error:&error];
            if(!error) {
                // Parse le JSON
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                // On recupere le code
                NSString* codeReturn = [jsonDict objectForKey:@"code"];
                if( [codeReturn  isEqualToString:@"0"]) {
                    // On recupere le resultat de la requete(result)
                    NSDictionary* result = [jsonDict objectForKey:@"result"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!" message:@"Your account is created" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    NSLog(@"result %@",[result objectForKey:@"email"]);
                    //On créer le user a partir du result
                    User* newUser = [User new];
                    
                    newUser.email = [result objectForKey:@"email"];
                    newUser.firstname = [result objectForKey:@"firstname"];
                    newUser.lastname = [result objectForKey:@"lastname"];
                    newUser.token = [result objectForKey:@"token"];
                    
                    //On enregistre
                    [self createSessionWithUser:newUser];
                    
                    
                    //Redirection si loggué
                    ShoppingListViewController* formViewController = [ShoppingListViewController new];
                    [self.navigationController pushViewController:formViewController animated:YES];
                // Gestion erreur retour de l'API
                } else if ([codeReturn isEqualToString:@"1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Missing required parameter(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else if ([codeReturn isEqualToString:@"2"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Email already registered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else if ([codeReturn isEqualToString:@"5"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Internal server error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                NSLog(@"%@@", str);
            }
        }
    }
}

//Permet de creer la session avec le user en parametre
- (void) createSessionWithUser:(User* ) newUser{
    
    //[NSKeyedArchiver archiveRootObject:user toFile:[self filePath]];
    
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

// Retourne le chemin du fichier
/*- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}*/


-(BOOL)isFormDataValid{
    // test sur le formulaire et sa validite
    NSString *errorMessage = nil;
    UITextField *errorField;
    // Regex email format
    NSString *emailRegex = @"[a-zA-Z0-9.\\-_]{2,32}@[a-zA-Z0-9.\\-_]{2,32}\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [regExPredicate evaluateWithObject:self.email.text];
    // test email vide
    if([self.email.text isEqualToString:@""])
    {
        errorMessage = @"Please enter email";
        errorField = self.email;
    }
    // Test regex Ok
    else if (!validEmail)
    {
        errorMessage = @"Please enter a valid email";
        errorField = self.email;
    }
    // Test password vide
    else if([self.password.text isEqualToString:@""])
    {
        errorMessage = @"Please enter password";
        errorField = self.password;
    }
    // test firstname vide
    else if([self.firstname.text isEqualToString:@""])
    {
        errorMessage = @"Please enter firstname";
        errorField = self.firstname;
    }
    
    // Affichage alert d'erreur plus selection du field en erreur
    if (errorMessage) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [errorField becomeFirstResponder];
        return NO;
    }else{
        return YES;
    }
    
}
@end
