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

#import "BNGEventType.h"
#import "BNGMarketFilter.h"
#import "BNGEvent.h"
#import "BNGEventResult.h"
#import "BNGEventTypeResult.h"
#import "BNGMarketCatalogue.h"
#import "BNGMarketCatalogueFilter.h"
#import "BNGMarketCatalogue.h"
#import "BNGPriceProjection.h"
#import "BNGMarketBook.h"
#import "BNGRunner.h"
#import "BNGLimitOrder.h"
#import "BNGPriceSize.h"
#import "BNGPlaceInstruction.h"
#import "BNGPlaceExecutionReport.h"
#import "BNGPlaceInstructionReport.h"
#import "BNGCancelInstruction.h"
#import "BNGCancelExecutionReport.h"
#import "NSString+RandomCustomerReferenceId.h"

@implementation APINGExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // first we need to register the application key with the shared singleton instance ...
    // for your own application, you'd need to request an application key from https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG
    // For the sake of the hack day, the following three variables should work fine.
    // Should you want to distribute your application after the hack day, check out the link above
    // to request your own application key.
    NSString *appKey = @"PRBQYVVI6GIgqQjv";
    NSString *scheme = @"iosapingsample";
    NSString *product = @"SampleApplicationForAPING";
    [[APING sharedInstance] registerApplicationKey:appKey ssoKey:nil];

    // need to register the login URL protocol which the redirect url will hit once the login API call succeeds.
    [BNGLoginURLProtocol registerWithScheme:scheme];

    // try to log in ...
    NSURLRequest *request = [BNGAccount loginWithUserName:@"USERNAME_GOES_HERE" password:@"PASSWORD_GOES_HERE" product:product redirectUrl:[scheme stringByAppendingString:@"://ios.betfair.com/login"] completionBlock:^(NSString *ssoKey, NSError *connectionError, BNGAPIError *apiError) {
        
        if (ssoKey.length) {
            // once we have the ssoKey back from the login API call, we should set it in the shared instance so other API calls can make use of it.
            [APING sharedInstance].ssoKey = ssoKey;
            
            // before we do anything, lets see if we have funds to place a bet
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