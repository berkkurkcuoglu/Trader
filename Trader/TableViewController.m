//
//  TableViewController.m
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import "TableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void) passAccNum:(NSInteger) accNum{
    _accountNumber = accNum;
}
- (void) passAccInfo:(NSString*) username :(NSString*) password{
    _username = username;
    _password = password;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPortfolios];
    [self.tableView reloadData];
    [self.tableView setSectionHeaderHeight:40];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadPortfolios{
    //connect to service and load portfolios using accNum
    NSString *url_string = [NSString stringWithFormat: @"https://tb.matriksdata.com/9999/Integration.aspx?MsgType=AN&CustomerNo=0&Username=%@&Password=%@&AccountID=%ld&ExchangeID=4&OutputType=2",_username,_password,_accountNumber];
    /*
     //sync service call if required
     NSError *error;
     NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error)
        NSLog(@"%@",error);
    else{
        NSDictionary *result = [jsonData objectForKey:@"Result"];
        _state = [[result objectForKey:@"State"] boolValue];
        _desc = [result objectForKey:@"Description"];
        if(_state == NO){
            NSLog(@"%@",_desc);
        }
        else{
            _portfolios = [[NSMutableArray alloc] init];
            NSArray *itemData = [jsonData objectForKey:@"Item"];
            for(NSDictionary *item in itemData){
                Portfolio *portfolio = [[Portfolio alloc] init:[item objectForKey:@"Symbol"] :[[item objectForKey:@"Qty_T2"] doubleValue] :[[item objectForKey:@"LastPx"] doubleValue]];
                [_portfolios addObject:portfolio];
            }
        }
    }*/
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:url_string];
    //async service call
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {                                                
                                                if (error)
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        NSLog(@"%@",error);//print error if service call fails
                                                    });
                                                else {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                        NSDictionary *result = [jsonData objectForKey:@"Result"];
                                                        _state = [[result objectForKey:@"State"] boolValue];
                                                        _desc = [result objectForKey:@"Description"];
                                                        if(_state == NO){
                                                            NSLog(@"%@",_desc); //print description received from service if state is false
                                                        }
                                                        else{
                                                            //generate portfolio objects from item list in received json and add them to an array
                                                            _portfolios = [[NSMutableArray alloc] init];
                                                            NSArray *itemData = [jsonData objectForKey:@"Item"];
                                                            for(NSDictionary *item in itemData){
                                                                Portfolio *portfolio = [[Portfolio alloc] init:[item objectForKey:@"Symbol"] :[[item objectForKey:@"Qty_T2"] doubleValue] :[[item objectForKey:@"LastPx"] doubleValue]];
                                                                [_portfolios addObject:portfolio];
                                                            }
                                                        }
                                                    });
                                                }
                                            }];
    [dataTask resume];
}
-(void)addBorders:(PortfolioCell*) cell{
    //add borders to labels of cell used in tableview
    [[[cell menkulLabel] layer] setBorderColor:[UIColor blackColor].CGColor];
    [[[cell menkulLabel] layer] setBorderWidth:1.0];
    [[[cell miktarLabel] layer] setBorderColor:[UIColor blackColor].CGColor];
    [[[cell miktarLabel] layer] setBorderWidth:1.0];
    [[[cell fiyatLabel] layer] setBorderColor:[UIColor blackColor].CGColor];
    [[[cell fiyatLabel] layer] setBorderWidth:1.0];
    [[[cell tutarLabel] layer] setBorderColor:[UIColor blackColor].CGColor];
    [[[cell tutarLabel] layer] setBorderWidth:1.0];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //create header for the table
    PortfolioCell *cell = (PortfolioCell*)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
    [[cell menkulLabel] setText:@" Menkul "];
    [[cell menkulLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [[cell menkulLabel] setBackgroundColor:[UIColor lightGrayColor]];
    [[cell miktarLabel] setText:@" Miktar T2 "];
    [[cell miktarLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [[cell miktarLabel] setBackgroundColor:[UIColor lightGrayColor]];
    [[cell fiyatLabel] setText:@" Fiyat "];
    [[cell fiyatLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [[cell fiyatLabel] setBackgroundColor:[UIColor lightGrayColor]];
    [[cell tutarLabel] setText:@" Tutar "];
    [[cell tutarLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [[cell tutarLabel] setBackgroundColor:[UIColor lightGrayColor]];
    [self addBorders:cell];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    //create footer string for the table
    double total = 0;
    if(_state){
        for(Portfolio *port in _portfolios){
            total += [port total];
        }
        return [NSString stringWithFormat:@"Toplam Tutar:\t%@",[self formattedNumber:total fraction:3]]; // return total value if state is true
    }
    else
        return [NSString stringWithFormat:@"%@",_desc]; // return description from json if state is false
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _portfolios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //associate tableview with portfolios and create cells
    PortfolioCell *cell = (PortfolioCell*)[tableView dequeueReusableCellWithIdentifier:@"PortfolioCell" forIndexPath:indexPath];
    Portfolio *p = [_portfolios objectAtIndex:indexPath.row];
    [[cell menkulLabel] setText:[NSString stringWithFormat:@" %@ ",[p symbol]]];
    [[cell miktarLabel] setText:[self formattedNumber:[p quantity] fraction:0]];
    [[cell fiyatLabel] setText:[self formattedNumber:[p lastPrice] fraction:2]];
    [[cell tutarLabel] setText:[self formattedNumber:[p total] fraction:2]];    
    [self addBorders:cell];
    return cell;
    
}

- (NSString*) formattedNumber:(double) number fraction:(NSInteger) fracNum{
    //format number
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:fracNum];
    [numberFormatter setMaximumFractionDigits:fracNum];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}


@end
