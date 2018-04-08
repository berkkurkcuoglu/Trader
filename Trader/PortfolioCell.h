//
//  PortfolioCell.h
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *menkulLabel;
@property (strong, nonatomic) IBOutlet UILabel *miktarLabel;
@property (strong, nonatomic) IBOutlet UILabel *fiyatLabel;
@property (strong, nonatomic) IBOutlet UILabel *tutarLabel;

@end
