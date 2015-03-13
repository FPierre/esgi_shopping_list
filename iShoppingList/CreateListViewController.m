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

- (IBAction)onTouchAdd:(id)sender {
    if (!self.list) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appspaces.fr/esgi/shopping_list/shopping_list/create.php?token=%@&name=%@", @"35e2be53f535dbbfd411681ac0e215a1", self.nameTextfield.text]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if (!error) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSString *codeReturn = [jsonDict objectForKey:@"code"];
            
            if ([codeReturn isEqualToString:@"0"]) {
                ShoppingList *newList = [ShoppingList new];
                NSDictionary *result = [jsonDict objectForKey:@"result"];

                newList.name = [result objectForKey:@"name"];
                
                if ([self.delegate respondsToSelector:@selector(createListViewControllerDidCreateShoppingList:)]) {
                    NSLog(@"1");
                    [self.delegate createListViewControllerDidCreateShoppingList:newList];
                }
            }
            /*else if ([codeReturn isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Missing required parameter(s)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([codeReturn isEqualToString:@"2"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Email already registered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([codeReturn isEqualToString:@"5"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Internal server error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            NSLog(@"%@@", str);*/
        }
    }
    
    
    /*
     
     if (self.list) {
     self.list.name = self.nameTextfield.text;
     
     if ([self.delegate respondsToSelector:@selector(createListViewControllerDidEditShoppingList:)]) {
     [self.delegate createListViewControllerDidEditShoppingList:self.list];
     }
     }
     else {
     ShoppingList *newList = [ShoppingList new];
     
     newList.name = self.nameTextfield.text;
     
     if ([self.delegate respondsToSelector:@selector(createListViewControllerDidCreateShoppingList:)]) {
     [self.delegate createListViewControllerDidCreateShoppingList:newList];
     }
     }*/

}

@end
