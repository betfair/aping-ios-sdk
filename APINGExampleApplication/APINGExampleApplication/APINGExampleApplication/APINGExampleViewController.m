// Copyright (c) 2013, The Sporting Exchange Limited
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 3. All advertising materials mentioning features or use of this software
// must display the following acknowledgement:
// This product includes software developed by The Sporting Exchange Limited.
// 4. Neither the name of The Sporting Exchange Limited nor the
// names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE SPORTING EXCHANGE LIMITED ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE SPORTING EXCHANGE LIMITED BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "APINGExampleViewController.h"

#import "APING.h"
#import "BNGAccount.h"
#import "BNGLoginURLProtocol.h"

#import "BNGAccountDetails.h"
#import "APINGExampleAccountDetailViewController.h"
#import "APINGExampleAppDelegate.h"
#import "NSString+RandomCustomerReferenceId.h"

@interface APINGExampleViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BNGAccountDetails *accountDetails;

@end

@implementation APINGExampleViewController

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
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor yellowColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"The user's first name is '%@'", self.accountDetails.firstName];
    
    return cell;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    APINGExampleAccountDetailViewController *controller = [[APINGExampleAccountDetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSLog(@"initWithCoder");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Accounts View Controller", @"");
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

#pragma mark Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

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

@end