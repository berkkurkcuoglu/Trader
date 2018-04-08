//
//  Portfolio.h
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Portfolio : NSObject

@property (nonatomic,strong) NSString *symbol;
@property (nonatomic) double quantity;
@property (nonatomic) double lastPrice;
@property (nonatomic) double total;

-(id)init: (NSString*)symbol :(double)quantity :(double)lastPrice;

@end
