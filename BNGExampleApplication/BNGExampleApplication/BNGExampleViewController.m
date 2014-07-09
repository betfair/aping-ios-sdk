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
            [BNGAccountFunds getAccountFundsWithCompletionBlock:^(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError) {
                
                if (!connectionError && !apiError) {
                    
                    NSLog(@"Got the account funds back for this user %@", accountFunds.availableToBetBalance);
                    
                    if ([accountFunds.availableToBetBalance compare:[NSNumber numberWithInt:2]] == NSOrderedAscending) {
                        NSLog(@"The accounts funds is less than 2. Will have issues placing a bet with this account as the minimum exchange bet is 2 GBP.");
                    }
                    
                    // try to get some event types
                    BNGMarketFilter *marketFilter = [[BNGMarketFilter alloc] init];
                    [BNGEventType listEventTypesWithMarketFilter:marketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
                        
                        if (results.count) {
                            // take the event type with the most amount of open markets
                            NSArray *sortedEventTypes = [results sortedArrayUsingComparator:^NSComparisonResult(BNGEventTypeResult *one, BNGEventTypeResult *two) {
                                return one.marketCount < two.marketCount;
                            }];
                            
                            BNGEventTypeResult *eventTypeWithMostOpenMarkets = (BNGEventTypeResult *)sortedEventTypes[0];
                            BNGMarketFilter *eventMarketFilter = [[BNGMarketFilter alloc] init];
                            eventMarketFilter.eventTypeIds = @[eventTypeWithMostOpenMarkets.eventType.identifier];
                            
                            // get a few events associated with this event type.
                            [BNGEvent listEventsWithFilter:eventMarketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
                                
                                if (results.count) {
                                    // take the first event and see if we can get a market id
                                    BNGEventResult *eventResult = results[0];
                                    BNGMarketCatalogueFilter *eventFilter = [[BNGMarketCatalogueFilter alloc] init];
                                    eventFilter.eventIds = @[eventResult.event.eventId];
                                    eventFilter.marketBettingTypes = @[@"ODDS"];
                                    
                                    [BNGMarketCatalogue listMarketCataloguesWithFilter:eventFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
                                        
                                        if (results.count) {
                                            // take the first result and see if we can get some prices for this market ...
                                            BNGMarketCatalogue *marketCatalogue = results[0];
                                            BNGPriceProjection *priceProjection = [[BNGPriceProjection alloc] init];
                                            priceProjection.priceData = @[[BNGPriceProjection stringFromPriceData:BNGPriceDataExTraded],
                                                                          [BNGPriceProjection stringFromPriceData:BNGPriceDataExAllOffers],
                                                                          [BNGPriceProjection stringFromPriceData:BNGPriceDataExBestOffers],
                                                                          [BNGPriceProjection stringFromPriceData:BNGPriceDataSPAvailable],
                                                                          [BNGPriceProjection stringFromPriceData:BNGPriceDataSPTraded]];
                                            [BNGMarketBook listMarketBooksForMarketIds:@[marketCatalogue.marketId]
                                                                       priceProjection:priceProjection
                                                                       completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
                                                                           
                                                                           if (results.count) {
                                                                               BNGMarketBook *marketBook = results[0];
                                                                               
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
                                                                                               BNGCancelInstruction *cancelInstruction = [[BNGCancelInstruction alloc] init];
                                                                                               cancelInstruction.betId = placedBetReport.betId;
                                                                                               [BNGOrder cancelOrdersForMarketId:marketBook.marketId instructions:@[cancelInstruction] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGCancelExecutionReport *cancelExecutionReport, NSError *cancelConnectionError, BNGAPIError *cancelApiError) {
                                                                                                   
                                                                                                   if (!connectionError && !apiError && cancelExecutionReport.errorCode == BNGExecutionReportErrorCodeUnknown && cancelExecutionReport.instructionReports.count) {
                                                                                                       NSLog(@"Successfully cancelled the bet");
                                                                                                   } else {
                                                                                                       NSLog(@"There was an error while cancelling the bet %@ %@ %d", cancelConnectionError.localizedDescription, cancelApiError, report.errorCode);
                                                                                                   }
                                                                                               }];
                                                                                           } else {
                                                                                               NSLog(@"There was an error while placing the bet %@ %@ %d", connectionError.localizedDescription, apiError, report.errorCode);
                                                                                           }
                                                                                       }];
                                                                                       break;
                                                                                   }
                                                                               }
                                                                               
                                                                           } else {
                                                                               NSLog(@"There was an error while retrieving the market book %@ %@", connectionError.localizedDescription, apiError);
                                                                           }
                                                                       }];
                                            
                                        } else {
                                            NSLog(@"There was an error while retrieving the market catalog %@ %@", connectionError.localizedDescription, apiError);
                                        }
                                    }];
                                } else {
                                    NSLog(@"There was an error while retrieving the event %@ %@", connectionError.localizedDescription, apiError);
                                }
                            }];
                        } else {
                            NSLog(@"There was an error while retrieving the event types %@ %@", connectionError.localizedDescription, apiError);
                        }
                    }];
                } else {
                    NSLog(@"There was an error while retrieving the event types %@ %@", connectionError.localizedDescription, apiError);
                }
            }];
        } else {
            NSLog(@"There was an error while logging in %@ %@", connectionError.localizedDescription, apiError);
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
