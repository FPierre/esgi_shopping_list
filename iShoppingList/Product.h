//
//  Product.h
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
    @private
    NSString *id_;
    NSString* name_;
    NSUInteger quantity_;
    double price_;
}

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSUInteger quantity;
@property (nonatomic) double price;


@end
