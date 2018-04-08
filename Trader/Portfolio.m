//
//  Portfolio.m
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import "Portfolio.h"

@implementation Portfolio

-(id)init: (NSString*)symbol :(double)quantity :(double)lastPrice{ //constructor to create portfolio object with given values
    _symbol = symbol;
    _quantity = quantity;
    _lastPrice = lastPrice;
    _total = quantity * lastPrice;
    
    return self;
}

@end
