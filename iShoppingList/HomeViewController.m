//
//  HomeViewController.m
//  iShoppingList
//
//  Created by Save92 on 19/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "HomeViewController.h"
#import "SBJson.h"
#import "SignUpViewController.h"
#import "ShoppingListViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize txtFieldEmail;
@synthesize txtFieldPassword;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
                        // on créer l'url
            NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/account/login.php?email=%@&password=%@", self.txtFieldEmail.text , self.txtFieldPassword.text]];
            NSURLRequest* requestLogin=[NSURLRequest requestWithURL:URL];
            NSError* error = nil;
            NSData* data = [NSURLConnection sendSynchronousRequest:requestLogin returningResponse:nil error:&error];
            if(!error) {
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                NSLog(@"jsonDict:%@", jsonDict);
                NSString* codeReturn = [jsonDict objectForKey:@"code"];
                if( [codeReturn  isEqualToString:@"0"]) {
                    NSLog(@"Login SUCCESS");
                    NSDictionary* result = [jsonDict objectForKey:@"result"];
                    NSLog(@"result:%@", result);
                    //On créer le user
                    User* newUser = [User new];
                    newUser.email = [result objectForKey:@"email"];
                    newUser.token = [result objectForKey:@"token"];
                    NSLog(@"newUserEmail:%@", newUser.email);
                    NSLog(@"newUserToken:%@", newUser.token);
                    
                    //On enregistre
                    //[self createSessionWithToken:newUser];
                    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                    
                    if (standardUserDefaults) {
                        [standardUserDefaults setObject:newUser.email forKey:@"email"];
                        [standardUserDefaults setObject:newUser.token forKey:@"token"];
                        [standardUserDefaults synchronize];
                        NSLog(@"Save ok!");
                    }
                    
                    //NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                    NSString *valEmail = nil;
                    NSString *valToken = nil;
                    
                    
                    if (standardUserDefaults) {
                        NSLog(@"standardUserDefaults Ok!");
                        valEmail = [standardUserDefaults objectForKey:@"email"];
                        valToken  = [standardUserDefaults objectForKey:@"token"];
                        NSLog(@"valEmail:%@", valEmail);
                        NSLog(@"valToken:%@", valToken);
                    }

                    
                    //Redirection si loggué
                    [self alertStatus:@"Logged in Successfully." :@"Login Success!"];
                    ShoppingListViewController* formViewController = [ShoppingListViewController new];
                    [self.navigationController pushViewController:formViewController animated:YES];
                    
                } else {
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

//- (void) createSessionWithToken:(User* ) user{
//    [NSKeyedArchiver archiveRootObject:user toFile:[self filePath]];
//}

// Retourne le chemin du fichier
- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}

- (IBAction)onTouchSignUp:(id)sender {
    SignUpViewController* formViewController = [SignUpViewController new];
    //formViewController.delegate = self;
    [self.navigationController pushViewController:formViewController animated:YES];
}



- (IBAction)backgroundClick:(id)sender {
  //  [txtFieldUsername resignFirstResponder];
  //  [txtFieldPassword resignFirstResponder];
}
@end
