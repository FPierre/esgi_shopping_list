//
//  ShoppingList.h
//  iShoppingList
//
//  Created by Save92 on 26/02/2015.
//  Copyright (c) 2015 Nicolas Save. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingList : NSObject {
    @private
    NSString* id_;
    NSString* name_;
    NSDate* created_date_;
    BOOL completed_;
}

@property (nonatomic, strong) NSString* Id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDate* created_date;
@property (nonatomic) BOOL completed;

@end
