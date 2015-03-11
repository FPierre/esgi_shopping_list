//
//  ShoppingListViewController.m
//  iShoppingList
//
//  Created by Save92 on 11/03/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "User.h"
#import "HomeViewController.h"

@interface ShoppingListViewController ()

@end

@implementation ShoppingListViewController
@synthesize helloName;
@synthesize userToken;
@dynamic User;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *valEmail = @"0";
    NSString *valToken = @"0";
    
    
    if (standardUserDefaults && [valEmail isEqualToString:@"0"] && [valToken  isEqualToString: @"0"]) {
        NSLog(@"standardUserDefaults Ok!");
        valEmail = [standardUserDefaults objectForKey:@"email"];
        valToken  = [standardUserDefaults objectForKey:@"token"];
        NSLog(@"valEmail:%@", valEmail);
        NSLog(@"valToken:%@", valToken);
    }
    User* user = [self createUserWithEmail:valEmail withToken:valToken];
    if (user.token != nil) {
        self.userToken.text = user.token;
    }
    if (user.email != nil) {
        self.helloName.text = (NSMutableString *)(@"Hi ! %@", user.email);
    }
    NSLog(@"%@",self.helloName.text);
    NSLog(@"%@",self.userToken.text);
    // Do any additional setup after loading the view from its nib.

    
}

- (User *)createUserWithEmail:(NSString *)email withToken:(NSString *)token {
    User* user = [User new];
    user.email = email;
    NSLog(@"user.email%@", user.email);
    user.token = token;
    NSLog(@"user.token%@", user.token);
    return user;
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

- (User *) user {
    NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]]);
        self.User = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    return self.User;
}

// Retourne le chemin du fichier
- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}

// pour se delog
- (void) logout {
    NSLog(@"Logout");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"Done");
    HomeViewController* formViewController = [HomeViewController new];
    [self.navigationController pushViewController:formViewController animated:YES];
    
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
