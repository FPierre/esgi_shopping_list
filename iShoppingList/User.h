//
//  User.h
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <Foundation/Foundation.h>

// Objet User
@interface User : NSObject <NSCoding> {
    @private
    NSString* firstname_;
    NSString* lastname_;
    NSString* email_;
    NSString* token_;
}

@property (nonatomic, strong) NSString* firstname;
@property (nonatomic, strong) NSString* lastname;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* token;

- (id) initWithCoder:(NSCoder  *) aDecoder;
- (void) encodeWithCoder:(NSCoder *) aCoder;
- (User *)createUserWithEmail:(NSString *)email withToken:(NSString *)token withFirstname:(NSString *)firstname withLastname:(NSString *)lastname;
- (User *) initWithUser:(User *) user;
- (void) logout;

@end
