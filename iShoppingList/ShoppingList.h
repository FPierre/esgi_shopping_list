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
    id id_;
    NSString* name_;
    NSDate* created_date_;
    BOOL completed_;
}

@end
