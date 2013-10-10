// Copyright (c) 2013 The Sporting Exchange Limited
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
// THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@class BNGAPIError;
@class BNGAccountFunds;
@class BNGAccountDetails;
@class BNGCurrentOrderSummaryReport;
@class BNGPlaceExecutionReport;
@class BNGCancelExecutionReport;
@class BNGReplaceExecutionReport;
@class BNGUpdateExecutionReport;

/** @name Completion Blocks */
typedef void(^BNGLoginCompletionBlock)(NSString *ssoKey, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGResultsCompletionBlock)(NSArray *results, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGAccountFundsCompletionBlock)(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGAccountDetailsCompletionBlock)(BNGAccountDetails *accountDetails, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGCurrentOrdersCompletionBlock)(BNGCurrentOrderSummaryReport *report, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGPlaceOrdersCompletionBlock)(BNGPlaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGCancelOrdersCompletionBlock)(BNGCancelExecutionReport *report, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGReplaceOrdersCompletionBlock)(BNGReplaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError);
typedef void(^BNGUpdateOrdersCompletionBlock)(BNGUpdateExecutionReport *report, NSError *connectionError, BNGAPIError *apiError);

/** @name Login Operations */
extern const struct BNGLoginOperation {
    __unsafe_unretained NSString *login;
} BNGLoginOperation;

/** @name Betting Operations */
extern const struct BNGBettingOperation {
    __unsafe_unretained NSString *cancelOrders;
    __unsafe_unretained NSString *listCompetitions;
    __unsafe_unretained NSString *listCountries;
    __unsafe_unretained NSString *listCurrentOrders;
    __unsafe_unretained NSString *listEvents;
    __unsafe_unretained NSString *listEventTypes;
    __unsafe_unretained NSString *listMarketBook;
    __unsafe_unretained NSString *listMarketCatalogue;
    __unsafe_unretained NSString *listMarketTypes;
    __unsafe_unretained NSString *listTimeRanges;
    __unsafe_unretained NSString *listVenues;
    __unsafe_unretained NSString *placeOrders;
    __unsafe_unretained NSString *replaceOrders;
    __unsafe_unretained NSString *updateOrders;
} BNGBettingOperation;

/** @name Account Operations */
extern const struct BNGAccountOperation {
    __unsafe_unretained NSString *getAccountFunds;
    __unsafe_unretained NSString *getAccountDetails;
} BNGAccountOperation;

extern NSString *const BNGBaseLoginString;
extern NSString *const BNGBaseURLString;
extern NSString *const BNGAPIVersion;

/**
 * Simple category on `NSURL` which includes two methods for returning betting and accounts APIs.
 */
@interface NSURL (APING)

/**
 * @param operation String for the opertation to be performed. This should be one of the BNGLoginOperation* constants.
 */
+ (NSURL *)betfairNGLoginURLForOperation:(NSString *)operation;

/**
 * @param operation String for the opertation to be performed. This should be one of the BNGBettingOperation* constants.
 * @return URL to the API endpoint for betting operations.
 */
+ (NSURL *)betfairNGBettingURLForOperation:(NSString *)operation;

/**
 * @param operation String for the opertation to be performed. This should be one of the BNGAccountOperation* constants.
 * @return URL to the API endpoint for account operations.
 */
+ (NSURL *)betfairNGAccountURLForOperation:(NSString *)operation;

@end
