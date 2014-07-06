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

#import <Foundation/Foundation.h>

@class BNGAccount;
@class BNGAccountFunds;
@class BNGAccountDetails;
@class BNGEvent;
@class BNGEventTypeResult;
@class BNGEventType;
@class BNGCurrentOrderSummaryReport;
@class BNGPlaceExecutionReport;
@class BNGCancelExecutionReport;
@class BNGReplaceExecutionReport;
@class BNGUpdateExecutionReport;

/**
 * Parses JSON responses from the API server into domain objects. Typically, this class is used internally by BNG classes and shouldn't have to be used by client code.
 */
@interface BNGAPIResponseParser : NSObject

/**
 * Given a JSON response dictionary, this method returns a list of `BNGEvent`s.
 * @param response JSON from the server based on a `listEvents` API call.
 * @return a collection of `BNGEvent`s.
 */
+ (NSArray *)parseBNGEventsFromResponse:(NSArray *)response;

/**
 * Given a JSON response dictionary, this method returns a list of `BNGMarketBook`s.
 * @param response JSON from the server based on a `marketBooks` API call.
 * @return a collection of `BNGMarketBook`s.
 */
+ (NSArray *)parseBNGMarketBooksFromResponse:(NSArray *)response;

/**
 * Given a JSON response dictionary, this method returns a list of `BNGMarketCatalogue`s.
 * @param response JSON from the server based on a `marketCatalogues` API call.
 * @return a collection of `BNGMarketCatalogue`s.
 */
+ (NSArray *)parseBNGMarketCataloguesFromResponse:(NSArray *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGCurrentOrderSummaryReport`.
 * @param response JSON from the server based on a `currentOrders` API call.
 * @return a `BNGCurrentOrderSummaryReport` object.
 */
+ (BNGCurrentOrderSummaryReport *)parseBNGCurrentOrderSummaryReportFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGAccountFunds`.
 * @param response JSON from the server based on a `accountFunds` API call.
 * @return a `BNGAccountFunds` object.
 */
+ (BNGAccountFunds *)parseBNGAccountFundsFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGAccountDetails`.
 * @param response JSON from the server based on a `accountDetails` API call.
 * @return a `BNGAccountDetails` object.
 */
+ (BNGAccountDetails *)parseBNGAccountDetailsFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGEventTypeResult`.
 * @param response JSON from the server based on a `eventTypes` API call.
 * @return a `BNGEventTypeResult` object.
 */
+ (BNGEventTypeResult *)parseBNGEventTypeResultsFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGPlaceExecutionReport`.
 * @param response JSON from the server based on a `placeOrders` API call.
 * @return a `BNGPlaceExecutionReport` object.
 */
+ (BNGPlaceExecutionReport *)parseBNGPlaceExecutionReportFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGCancelExecutionReport`.
 * @param response JSON from the server based on a `placeOrder` API call.
 * @return a `BNGCancelExecutionReport` object.
 */
+ (BNGCancelExecutionReport *)parseBNGCancelExecutionReportFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGReplaceExecutionReport`.
 * @param response JSON from the server based on a `replaceOrder` API call.
 * @return a `BNGReplaceExecutionReport` object.
 */
+ (BNGReplaceExecutionReport *)parseBNGReplaceExecutionReportFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns a `BNGReplaceExecutionReport`.
 * @param response JSON from the server based on a `replaceOrder` API call.
 * @return a `BNGReplaceExecutionReport` object.
 */
+ (BNGUpdateExecutionReport *)parseBNGUpdateExecutionReportFromResponse:(NSDictionary *)response;

/**
 * Given a JSON response dictionary, this method returns an array of `BNGCompetitionResult`s
 * @param response JSON from the server based on a `listCompetitions` API call.
 * @return an array of `BNGCompetitionResult`s
 */
+ (NSArray *)parseBNGCompetitionResultsFromResponse:(NSDictionary *)response;

@end
