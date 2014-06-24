//
//  BNGExampleViewController.m
//  BNGExampleApplication
//
//  Created by Sean O' Shea on 6/24/14.
//  Copyright (c) 2014 Betfair. All rights reserved.
//

#import "BNGExampleViewController.h"

#import <BNGAPI/BNGAPI.h>

@interface BNGExampleViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BNGAccountDetails *accountDetails;

@end

@implementation BNGExampleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Accounts View Controller", @"");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *appKey = @"ExchangeForiPhone";
    NSString *scheme = @"bfexsc";
    NSString *product = @"ExchangeForiPhone";
    [[APING sharedInstance] registerApplicationKey:appKey ssoKey:nil];
    
    // need to register the login URL protocol which the redirect url will hit once the login API call succeeds.
    [BNGLoginURLProtocol registerWithScheme:scheme];
    
    // try to log in ...
    NSURLRequest *request = [BNGAccount loginWithUserName:@"testaccountUS2" password:@"password01" product:product redirectUrl:[scheme stringByAppendingString:@"://ios.betfair.com/login"] completionBlock:^(NSString *ssoKey, NSError *connectionError, BNGAPIError *apiError) {
        
        if (ssoKey.length) {
            
            // once we have the ssoKey back from the login API call, we should set it in the shared instance so other API calls can make use of it.
            [APING sharedInstance].ssoKey = ssoKey;
            
            // lets see if we can figure out the account details for this user
            [BNGAccountDetails getAccountDetailsWithCompletionBlock:^(BNGAccountDetails *accountDetails, NSError *connectionError, BNGAPIError *apiError) {
                
                self.accountDetails = accountDetails;
                
                // tell the table to reload after it has retrieved data from the API server ...
                [self.tableView reloadData];
            }];
        } else {
            NSLog(@"There was an error while logging in %@ %@", connectionError.localizedDescription, apiError);
            NSLog(@"This error can happen if your product key is out of date or if your redirect url has been suspended");
            // see https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG for details on how to request an an application key
        }
    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountDetails ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *accountDetailsIdentifier = @"accountDetailsIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:accountDetailsIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accountDetailsIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"The user's first name is '%@'", self.accountDetails.firstName];
    
    return cell;
}

@end
