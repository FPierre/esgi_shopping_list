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
@synthesize userToken;

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [lists_ removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
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
    NSLog(@"ICI");
    NSLog(@"%@", list.name);
    [lists_ addObject:list];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)createListViewControllerDidEditShoppingList:(ShoppingList *)list {
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

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

/*- (User *) user {
    NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]]);
        self.User = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    return self.User;
}

// Retourne le chemin du fichier
- (NSString*) filePath {
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"session.archive"];
}*/

// pour se delog
- (void) logout {
    NSLog(@"Logout");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"Done");
    HomeViewController* formViewController = [HomeViewController new];
    [self.navigationController pushViewController:formViewController animated:YES];
    
}

@end



