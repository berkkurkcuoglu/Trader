//
//  ViewController.m
//  Trader
//
//  Created by berk on 2/3/18.
//  Copyright © 2018 berk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)submitAction:(id)sender {
    
    NSString *username = [_usernameField text]; //get username and password inputs
    NSString *password = [_passwordField text];
    if([username length] < 1 || [password length] < 1){
        [self loginError];
    }
    else{
        NSString *url_string = [NSString stringWithFormat: @"https://tb.matriksdata.com/9999/Integration.aspx?MsgType=A&CustomerNo=0&Username=%@&Password=%@&AccountID=0&ExchangeID=4&Output-//Type=2",username,password]; //generate service call url
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:url_string];
        //async service call
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error)
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSLog(@"%@",error); //display error if url call fails
                                                        });
                                                    else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                            NSDictionary *result = [jsonData objectForKey:@"Result"];
                                                            if([[result objectForKey:@"State"] boolValue] == NO){
                                                                [self loginError:[result objectForKey:@"Description"]];//display description if state is false
                                                            }
                                                            else{
                                                                //get accNum if state is true and switch to tableview
                                                                NSInteger accountNumber = [[jsonData objectForKey:@"DefaultAccount"] integerValue];
                                                                TableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
                                                                [vc passAccNum:accountNumber];
                                                                [self presentViewController:vc animated:YES completion:nil];
                                                            }
                                                        });
                                                    }
                                                }];
        [dataTask resume];
    }
    
        
    
}

-(void)loginError{
    //generate default error alertcontroller
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Hata!"
                                  message:[NSString stringWithFormat:@"Kullanici adi veya sifre hatali"]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Tamam"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)loginError:(NSString*)errorMessage{
    //generate error alertcontroller with custom error message
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Hata!"
                                  message: errorMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Tamam"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
