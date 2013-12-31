//
//  APINGExampleAccountDetailViewController.m
//  APINGExampleApplication
//
//  Created by seanoshea on 20/11/2013.
//  Copyright (c) 2013 Betfair. All rights reserved.
//

#import "APINGExampleAccountDetailViewController.h"

#import "BNGAccountFunds.h"

@interface APINGExampleAccountDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BNGAccountFunds *accountFunds;

@end

@implementation APINGExampleAccountDetailViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [BNGAccountFunds getAccountFundsWithCompletionBlock:^(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError) {
            
            self.accountFunds = accountFunds;
            
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"APINGExampleAccountDetailViewControllerCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"Available to Bet Balance: %.2f", [self.accountFunds.availableToBetBalance floatValue]];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }
    
    return cell;
}

@end
