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

#pragma mark Enums

typedef NS_ENUM(NSInteger, BNGMarketStatus) {
    BNGMarketStatusUnknown,
    BNGMarketStatusInactive,
    BNGMarketStatusOpen,
    BNGMarketStatusSuspended,
    BNGMarketStatusClosed
};

typedef NS_ENUM(NSInteger, BNGMatchProjection) {
    BNGMatchProjectionUnknown,
    BNGMatchProjectionNoRollup,
    BNGMatchProjectionRolledUpByPrice,
    BNGMatchProjectionRolledUpByAvgPrice,
};

#import "NSURL+APING.h"

@class BNGMarketFilter;
@class BNGPriceProjection;

#import "BNGOrder.h"

/**
 * A lightweight version of `BNGMarketCatalogue` which includes the prices available for each `BNGRunner` in a market.
 * Includes information necessary to place a bet on a market.
 */
@interface BNGMarketBook : NSObject

/**
 * Unique identifier for this `BNGMarketBook`.
 */
@property (nonatomic, copy) NSString *marketId;

/**
 * Indicates whether or not the market data contained in this object is delayed.
 */
@property (nonatomic, getter=isMarketDataDelayed) BOOL marketDataDelayed;

/**
 * Indicates whether this `BNGMarketBook` is OPEN, SUSPENDED, CLOSED, etc.
 */
@property (nonatomic) BNGMarketStatus status;

/**
 * The number of seconds an order is held until it is submitted into the market.
 * Orders are usually delayed when the market is in-play.
 */
@property (nonatomic) NSInteger betDelay;

/**
 * True if the market starting price has been reconciled.
 */
@property (nonatomic, getter=isBSPReconciled) BOOL BSPReconciled;

/**
 * Indicates whether this `BNGMarketBook` is in play or not.
 */
@property (nonatomic, getter=isInplay) BOOL inplay;

/**
 * Indicates how many `BNGRunners` in this `BNGMarket` can be marked as
 * winners when this market is settled.
 */
@property (nonatomic) NSInteger numberOfWinners;

/**
 * Number of `BNGRunners` associated with this `BNGMarket`.
 */
@property (nonatomic) NSInteger numberOfRunners;

/**
 * Runners can drop out from time to time. This property indicates how
 * many of the initial `BNGRunner`s are still marked as active in the market.
 */
@property (nonatomic) NSInteger numberOfActiveRunners;
@property (nonatomic) NSDate *lastMatchTime;

/**
 * How much money has been matched on this `BNGMarketBook`.
 */
@property (nonatomic) NSDecimalNumber *totalMatched;

/**
 * How much money is available on this `BNGMarketBook`.
 */
@property (nonatomic) NSDecimalNumber *totalAvailable;
@property (nonatomic, getter=isComplete) BOOL complete;

/**
 * Whether cross matching is enabled on this `BNGMarket`.
 */
@property (nonatomic, getter=isCrossMatching) BOOL crossMatching;

/**
 * Boolean property indicating whether or not runners can be removed from the market.
 */
@property (nonatomic) BOOL runnersVoidable;

/**
 * Snapshot version of the `BNGMarketBook`.
 */
@property (nonatomic) long long version;

/**
 * Collection of `BNGRunner`s associated with this `BNGMarketBook`.
 */
@property (nonatomic, copy) NSArray *runners;

/**
 * Given a BNGMarketFilter, this method finds a list of BNGMarketBooks.
 * @param priceProjection defines what prices will be requested.
 * @param completionBlock executed once the API call returns.
 */
+ (void)listMarketBooksForMarketIds:(NSArray *)marketIds
                    priceProjection:(BNGPriceProjection *)priceProjection
                    completionBlock:(BNGResultsCompletionBlock)completionBlock;

/**
 * Given a BNGMarketFilter, this method finds a list of BNGMarketBooks.
 * @param priceProjection defines what prices will be requested.
 * @param orderProjection 
 * @param matchProjection   
 * @param completionBlock executed once the API call returns.
 */
+ (void)listMarketBooksForMarketIds:(NSArray *)marketIds
                    priceProjection:(BNGPriceProjection *)priceProjection
                    orderProjection:(BNGOrderProjection)orderProjection
                    matchProjection:(BNGMatchProjection)matchProjection
                    completionBlock:(BNGResultsCompletionBlock)completionBlock;

/**
 * Given an marketStatus NSString, this method returns the corresponding `BNGMarketStatus`
 * @param marketStatus NSString representation of a `BNGMarketStatus`
 * @return a `BNGMarketStatus` which corresponds to the marketStatus parameter.
 */
+ (BNGMarketStatus)marketStatusFromString:(NSString *)marketStatus;

/**
 * Given an `BNGMatchProjection` matchProjection, this method returns the corresponding NSString
 * @param matchProjection a 'BNGMatchProjection'
 * @return a NSString which corresponds to the matchProjection parameter.
 */
+ (NSString *)stringFromMatchProjection:(BNGMatchProjection)matchProjection;

@end