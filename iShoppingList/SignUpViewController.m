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
            // on créer l'url
            NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/account/subscribe.php?email=%@&firstname=%@&password=%@&lastname=%@", self.email.text , self.firstname.text,self.password.text, self.lastname.text]];
            NSURLRequest* requestSubscribe=[NSURLRequest requestWithURL:URL];
            NSError* error = nil;
            NSData* data = [NSURLConnection sendSynchronousRequest:requestSubscribe returningResponse:nil error:&error];
            if(!error) {
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                NSString* codeReturn = [jsonDict objectForKey:@"code"];
                if( [codeReturn  isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!" message:@"Your account is created" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    //On créer le user
                    User* newUser = [User new];
                    newUser.email = [jsonDict objectForKey:@"email"];
                    newUser.firstname = [jsonDict objectForKey:@"firstname"];
                    newUser.lastname = [jsonDict objectForKey:@"lastname"];
                    newUser.token = [jsonDict objectForKey:@"token"];
                    
                    //On enregistre
                    [self createSessionWithUser:newUser];
                    
                    
                    //Redirection si loggué
                    ShoppingListViewController* formViewController = [ShoppingListViewController new];
                    [self.navigationController pushViewController:formViewController animated:YES];

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

- (void) createSessionWithUser:(User* ) user{
    
    [NSKeyedArchiver archiveRootObject:user toFile:[self filePath]];
}

// Retourne le chemin du fichier
- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}

-(BOOL)isFormDataValid{
    
    NSString *errorMessage = nil;
    UITextField *errorField;
    NSString *emailRegex = @"[a-zA-Z0-9.\\-_]{2,32}@[a-zA-Z0-9.\\-_]{2,32}\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [regExPredicate evaluateWithObject:self.email.text];
    
    if([self.email.text isEqualToString:@""])
    {
        errorMessage = @"Please enter email";
        errorField = self.email;
    }
    else if (!validEmail)
    {
        errorMessage = @"Please enter a valid email";
        errorField = self.email;
    }
    else if([self.password.text isEqualToString:@""])
    {
        errorMessage = @"Please enter password";
        errorField = self.password;
    }
    else if([self.firstname.text isEqualToString:@""])
    {
        errorMessage = @"Please enter firstname";
        errorField = self.firstname;
    }
    
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
