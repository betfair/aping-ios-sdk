//
//  APINGExampleAccountDetailViewController.h
//  APINGExampleApplication
//
//  Created by seanoshea on 20/11/2013.
//  Copyright (c) 2013 Betfair. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNGAccountDetails;

@interface APINGExampleAccountDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BNGAccountDetails *accountDetails;

@end
