// Copyright (c) 2013 - 2014 The Sporting Exchange Limited
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

#import "BNGExampleViewController.h"

#import <BNGAPI/BNGAPI.h>

@interface BNGExampleViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *logMessages;

@end

@implementation BNGExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.title = NSLocalizedString(@"APING Demo", @"");
    self.logMessages = [NSMutableArray array];
    
    // some preliminary APING setup first. You will need to change this to your specific appKey/scheme/product/username/password
    NSString *appKey = @"ExchangeForiPhone";
    NSString *scheme = @"bfexsc";
    NSString *product = @"ExchangeForiPhone";
    NSString *username = @"testaccountUS2";
    NSString *password = @"password01";
    [[APING sharedInstance] registerApplicationKey:appKey ssoKey:nil];
    // need to register the login URL protocol which the redirect url will hit once the login API call succeeds.
    [BNGLoginURLProtocol registerWithScheme:scheme];
    
    // lets log in
    [self authenticateForUsername:username password:password product:product scheme:scheme];
}

#pragma mark API Calls

- (void)authenticateForUsername:(NSString *)username password:(NSString *)password product:(NSString *)product scheme:(NSString *)scheme
{
    [self addLogMessage:NSLocalizedString(@"Logging in to APING", nil)];

    NSURLRequest *request = [BNGAccount loginWithUserName:username password:password product:product redirectUrl:[scheme stringByAppendingString:@"://ios.betfair.com/login"] completionBlock:^(NSString *ssoKey, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError && ssoKey.length) {
            // once we have the ssoKey back from the login API call, we should set it in the shared instance so other API calls can make use of it.
            [APING sharedInstance].ssoKey = ssoKey;
            // lets see if we can figure out the account details for this user
            [self getAccountFunds];
        } else {
            [self logError:@"There was an error while logging in %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
}

- (void)getAccountFunds
{
    [self addLogMessage:NSLocalizedString(@"Getting Account Funds", nil)];
    
    [BNGAccountFunds getAccountFundsWithCompletionBlock:^(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError) {
            NSLog(@"Got the account funds back for this user %@", accountFunds.availableToBetBalance);
            if ([accountFunds.availableToBetBalance compare:[NSNumber numberWithInt:2]] == NSOrderedAscending) {
                NSLog(@"The accounts funds is less than 2. Will have issues placing a bet with this account as the minimum exchange bet is 2 GBP.");
            }
            [self listEventTypes];
        } else {
            [self logError:@"There was an error while retrieving the balances for this user %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
}

- (void)listEventTypes
{
    [self addLogMessage:NSLocalizedString(@"Listing Event Types", nil)];
    
    // try to get some event types
    BNGMarketFilter *marketFilter = [[BNGMarketFilter alloc] init];
    [BNGEventType listEventTypesWithMarketFilter:marketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError && results.count) {
            // take the event type with the most amount of open markets
            NSArray *sortedEventTypes = [results sortedArrayUsingComparator:^NSComparisonResult(BNGEventTypeResult *one, BNGEventTypeResult *two) {
                return one.marketCount < two.marketCount;
            }];
            // get a few events associated with this event type.
            BNGEventTypeResult *eventTypeWithMostOpenMarkets = (BNGEventTypeResult *)sortedEventTypes[0];
            [self listEventsForEventType:eventTypeWithMostOpenMarkets.eventType];
        } else {
            [self logError:@"There was an error while retrieving the event types %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
}

- (void)listEventsForEventType:(BNGEventType *)eventType
{
    [self addLogMessage:NSLocalizedString(@"Listing Events", nil)];
    
    BNGMarketFilter *eventMarketFilter = [[BNGMarketFilter alloc] init];
    eventMarketFilter.eventTypeIds = @[eventType.identifier];
    [BNGEvent listEventsWithFilter:eventMarketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError && results.count) {
            // take the first event and see if we can get a market id
            BNGEventResult *eventResult = results[0];
            [self listMarketCataloguesForEvent:eventResult.event];
        } else {
            [self logError:@"There was an error while retrieving the event %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
}

- (void)listMarketCataloguesForEvent:(BNGEvent *)event
{
    [self addLogMessage:NSLocalizedString(@"Listing Market Catalogues", nil)];
    
    BNGMarketCatalogueFilter *eventFilter = [[BNGMarketCatalogueFilter alloc] init];
    eventFilter.eventIds = @[event.eventId];
    eventFilter.marketBettingTypes = @[@"ODDS"];
    [BNGMarketCatalogue listMarketCataloguesWithFilter:eventFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError && results.count) {
            // take the first result and see if we can get some prices for this market ...
            BNGMarketCatalogue *marketCatalogue = results[0];
            [self listMarketBooksForMarketCatalogue:marketCatalogue];
        } else {
            [self logError:@"There was an error while retrieving the market catalog %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
}

- (void)listMarketBooksForMarketCatalogue:(BNGMarketCatalogue *)marketCatalogue
{
    [self addLogMessage:NSLocalizedString(@"Listing Market Books", nil)];
    
    BNGPriceProjection *priceProjection = [[BNGPriceProjection alloc] init];
    priceProjection.priceData = @[[BNGPriceProjection stringFromPriceData:BNGPriceDataExTraded],
                                  [BNGPriceProjection stringFromPriceData:BNGPriceDataExAllOffers],
                                  [BNGPriceProjection stringFromPriceData:BNGPriceDataExBestOffers],
                                  [BNGPriceProjection stringFromPriceData:BNGPriceDataSPAvailable],
                                  [BNGPriceProjection stringFromPriceData:BNGPriceDataSPTraded]];
    [BNGMarketBook listMarketBooksForMarketIds:@[marketCatalogue.marketId]
                               priceProjection:priceProjection
                               completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
                                   
                                   if (!connectionError && !apiError && results.count) {
                                       BNGMarketBook *marketBook = results[0];
                                       // we have a market, lets place a bet
                                       [self placeOrdersForMarketBook:marketBook];
                                   } else {
                                       [self logError:@"There was an error while retrieving the market book %@ %@" connectionError:connectionError apiError:apiError];
                                   }
                               }];
}

- (void)placeOrdersForMarketBook:(BNGMarketBook *)marketBook
{
    [self addLogMessage:NSLocalizedString(@"Placing Bet", nil)];
    
    NSArray *runners = [marketBook.runners sortedArrayUsingComparator:^NSComparisonResult(BNGRunner *one, BNGRunner *two) {
        return one.lastPriceTraded < two.lastPriceTraded;
    }];
    
    // find an active runner ...
    for (BNGRunner *runner in runners) {
        
        if (runner.status == BNGRunnerStatusActive) {
            // place an unmatched bet on an active runner
            BNGLimitOrder *order = [[BNGLimitOrder alloc] init];
            order.priceSize = [[BNGPriceSize alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:@"100"] size:[NSDecimalNumber decimalNumberWithString:@"2"]];
            order.selectionId = runner.selectionId;
            order.persistenceType = BNGPersistanceTypeLapse;
            
            BNGPlaceInstruction *placeOrder = [[BNGPlaceInstruction alloc] init];
            placeOrder.selectionId = runner.selectionId;
            placeOrder.limitOrder = order;
            placeOrder.side = BNGSideBack;
            placeOrder.orderType = BNGOrderTypeLimit;
            
            [BNGOrder placeOrdersForMarketId:marketBook.marketId instructions:@[placeOrder] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGPlaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
                
                if (!connectionError && !apiError && report.errorCode == BNGExecutionReportErrorCodeUnknown && report.instructionReports.count) {
                    // turn around and cancel the bet immediately
                    BNGPlaceInstructionReport *placedBetReport = report.instructionReports[0];
                    [self cancelOrdersForMarketId:marketBook.marketId betId:placedBetReport.betId];
                } else {
                    [self logError:@"There was an error while placing the bet %@ %@" connectionError:connectionError apiError:apiError];
                }
            }];
            break;
        }
    }
}

- (void)cancelOrdersForMarketId:(NSString *)marketId betId:(NSString *)betId
{
    [self addLogMessage:NSLocalizedString(@"Cancelling Bet", nil)];
    
    BNGCancelInstruction *cancelInstruction = [[BNGCancelInstruction alloc] init];
    cancelInstruction.betId = betId;
    [BNGOrder cancelOrdersForMarketId:marketId instructions:@[cancelInstruction] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGCancelExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        if (!connectionError && !apiError && report.errorCode == BNGExecutionReportErrorCodeUnknown && report.instructionReports.count) {
            [self addLogMessage:NSLocalizedString(@"Cancelled Bet", nil)];
        } else {
            [self logError:@"There was an error while cancelling the bet %@ %@" connectionError:connectionError apiError:apiError];
        }
    }];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logMessages.count ? 1 : 0;
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
    
    NSString *logMessage = self.logMessages[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", logMessage];
    
    return cell;
}

- (void)addLogMessage:(NSString *)message
{
    [self.logMessages addObject:message];
    [self.tableView reloadData];
}

- (void)logError:(NSString *)error connectionError:(NSError *)connectionError apiError:(BNGAPIError *)apiError
{
    NSLog(error, connectionError.localizedDescription, apiError);
    [self addLogMessage:NSLocalizedString(@"There was an error - please consult the Console", nil)];
}

@end
