//
//  Product.m
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize Id = id_;
@synthesize name = name_;
@synthesize quantity = quantity_;
@synthesize price = price_;

- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super init];
    if(self) {
        self.Id = [aDecoder decodeIntegerForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.price = [aDecoder decodeDoubleForKey:@"price"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.Id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.quantity forKey:@"quantity"];
    [aCoder encodeDouble:self.price forKey:@"price"];
}

@end
