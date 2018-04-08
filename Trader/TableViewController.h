//
//  TableViewController.h
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Portfolio.h"
#include "PortfolioCell.h"

@interface TableViewController : UITableViewController

@property (nonatomic) NSInteger accountNumber;
@property (nonatomic) BOOL state;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableArray *portfolios;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
- (void) passAccNum:(NSInteger) accNum;
- (void) passAccInfo:(NSString*) username :(NSString*) password;
@end
