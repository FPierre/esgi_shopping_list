//
//  User.m
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize firstname = firstname_;
@synthesize lastname = lastname_;
@synthesize email = email_;
@synthesize token = token_;


- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super init];
    if(self) {
        self.firstname = [aDecoder decodeObjectForKey:@"firstname"];
        self.lastname = [aDecoder decodeObjectForKey:@"lastname"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.firstname forKey:@"firstname"];
    [aCoder encodeObject:self.lastname forKey:@"lastname"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.token forKey:@"token"];
}


@end
