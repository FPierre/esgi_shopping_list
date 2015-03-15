//
//  ShoppingList.m
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "ShoppingList.h"

@implementation ShoppingList
@synthesize Id = id_;
@synthesize name = name_;
@synthesize created_date = created_date_;
@synthesize completed = completed_;

- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super init];
    if(self) {
        self.Id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.created_date = [aDecoder decodeObjectForKey:@"created_date"];
        self.completed = [aDecoder decodeObjectForKey:@"completed"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.Id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.created_date forKey:@"created_date"];
    [aCoder encodeBool:self.completed forKey:@"completed"];
}


@end
