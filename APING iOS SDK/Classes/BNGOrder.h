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

#import "NSURL+APING.h"

#pragma mark Enums

typedef NS_ENUM(NSInteger, BNGOrderType) {
    BNGOrderTypeLimitUnknown,
    BNGOrderTypeLimit,
    BNGOrderTypeLimitOnClose,
    BNGOrderTypeMarketOnClose,
};

typedef NS_ENUM(NSInteger, BNGOrderStatus) {
    BNGOrderStatusUnknown,
    BNGOrderStatusExecutionComplete,
    BNGOrderStatusExecutable,
};

typedef NS_ENUM(NSInteger, BNGPersistanceType) {
    BNGPersistanceTypeUnknown,
    BNGPersistanceTypeLapse,
    BNGPersistanceTypePersist,
    BNGPersistanceTypeMarketOnClose,
};

typedef NS_ENUM(NSInteger, BNGSide) {
    BNGSideUnknown,
    BNGSideBack,
    BNGSideLay,
};

typedef NS_ENUM(NSInteger, BNGOrderProjection) {
    BNGOrderProjectionUnknown,
    BNGOrderProjectionAll,
    BNGOrderProjectionExecutable,
    BNGOrderProjectionExecutionComplete,
};

typedef NS_ENUM(NSInteger, BNGOrderBy) {
    BNGOrderByUnknown,
    BNGOrderByBet,
    BNGOrderByMarket,
};

typedef NS_ENUM(NSInteger, BNGOrderSortDir) {
    BNGOrderSortDirUnknown,
    BNGOrderSortDirEarliestToLatest,
    BNGOrderSortDirLatestToEarliest,
};

@class BNGPriceSize;
@class BNGTimeRange;

/**
 * A `BNGOrder` is a placed bet (either matched, unmatched or settled).
 */
@interface BNGOrder : NSObject

/**
 * Unique identifier for this bet.
 */
@property (nonatomic, copy) NSString *betId;

/**
 * Unique identifier for this market associated with this bet.
 */
@property (nonatomic, copy) NSString *marketId;

/**
 * Unique identifier for the `BNGRunner` on which this `BNGOrder` was placed.
 */
@property (nonatomic) long long selectionId;
@property (nonatomic) BNGOrderType orderType;

/**
 * Indicates whether this `BNGOrder` is fully executed or if there is some of this
 * `BNGOrder` which is still unmatched.
 */
@property (nonatomic) BNGOrderStatus status;

/**
 * Indicates whether this `BNGOrder` will be kept open when the market associated with
 * this `BNGOrder` goes in play.
 */
@property (nonatomic) BNGPersistanceType persistenceType;

/**
 * Indicates whether this `BNGOrder` is a back or lay bet.
 */
@property (nonatomic) BNGSide side;

/**
 * Pricing information for this `BNGOrder`.
 */
@property (nonatomic) BNGPriceSize *priceSize;

/**
 * Optional property which identifies the regulartor associated with this `BNGOrder`.
 */
@property (nonatomic, copy) NSString *regulatorCode;
@property (nonatomic) NSDecimalNumber *bspLiability;
@property (nonatomic) NSDecimalNumber *handicap;

/**
 * Indicates when this `BNGOrder` was placed.
 */
@property (nonatomic) NSDate *placedDate;
@property (nonatomic) NSDecimalNumber *avgPriceMatched;

/**
 * How much of this `BNGOrder` was matched.
 */
@property (nonatomic) NSDecimalNumber *sizeMatched;

/**
 * How much of this `BNGOrder` has been left unmatched.
 */
@property (nonatomic) NSDecimalNumber *sizeRemaining;
@property (nonatomic) NSDecimalNumber *sizeLapsed;
@property (nonatomic) NSDecimalNumber *sizeCancelled;
@property (nonatomic) NSDecimalNumber *sizeVoided;

#pragma mark API Calls

/**
 * Allows a client to retrive ALL bets (matched, unmatched) for the currently authenticated user.
 * @param completionBlock executed once the API call returns.
 */
+ (void)listCurrentOrdersWithCompletionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to retrive bet details based on bet ids.
 * @param betIds collection of bet ids.
 * @param completionBlock executed once the API call returns.
 */
+ (void)listCurrentOrdersForBetIds:(NSArray *)betIds completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to retrive bet details based on market ids.
 * @param marketIds collection of market ids.
 * @param completionBlock executed once the API call returns.
 */
+ (void)listCurrentOrdersForMarketIds:(NSArray *)marketIds completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to retrive bet details on several parameters. All parameters in this list are optional.
 * @param betIds collection of bet ids.
 * @param marketIds collection of market ids.
 * @param orderProjection dictates whether or not to limit the response to matched or unmatched bets.
 * @param placedDateRange from/to times for when the bets were placed.
 * @param orderBy dictates how the bets are ordered in the response.
 * @param sortDir dictates how the sorting direction for the bets in the response.
 * @param fromRecord narrows the response to a particular 'from' index.
 * @param toRecord narrows the response to a particular 'to' index.
 * @param completionBlock executed once the API call returns.
 */
+ (void)listCurrentOrdersForBetIds:(NSArray *)betIds
                         marketIds:(NSArray *)marketIds
                   orderProjection:(BNGOrderProjection)orderProjection
                   placedDateRange:(BNGTimeRange *)placedDateRange
                           orderBy:(BNGOrderBy)orderBy
                           sortDir:(BNGOrderSortDir)sortDir
                        fromRecord:(NSInteger)fromRecord
                          toRecord:(NSInteger)toRecord
                   completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to execute a set of place betting instructions on a particular market.
 * @param marketId market on which to place the bet.
 * @param instructions collection of betting place instructions to execute on the market.
 * @param customerRef Optional parameter allowing the client to pass a unique string (up to 32 chars) that is used to de-dupe mistaken re-submissions.
 * @param completionBlock executed once the API call returns.
 */
+ (void)placeOrdersForMarketId:(NSString *)marketId
                  instructions:(NSArray *)instructions
                   customerRef:(NSString *)customerRef
               completionBlock:(BNGPlaceOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to execute a set of cancel betting instructions on a particular market.
 * @param marketId market on which to cancel the bet.
 * @param instructions collection of betting cancel instructions to execute on the market.
 * @param customerRef Optional parameter allowing the client to pass a unique string (up to 32 chars) that is used to de-dupe mistaken re-submissions.
 * @param completionBlock executed once the API call returns.
 */
+ (void)cancelOrdersForMarketId:(NSString *)marketId
                   instructions:(NSArray *)instructions
                    customerRef:(NSString *)customerRef
                completionBlock:(BNGCancelOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to replace a set of orders on a particular market. It's basically a batch
 * cancel followed by a batch place.
 * @param marketId market on which to cancel the bet.
 * @param instructions collection of betting replace instructions to execute on the market.
 * @param customerRef Optional parameter allowing the client to pass a unique string (up to 32 chars) that is used to de-dupe mistaken re-submissions.
 * @param completionBlock executed once the API call returns.
 */
+ (void)replaceOrdersForMarketId:(NSString *)marketId
                    instructions:(NSArray *)instructions
                     customerRef:(NSString *)customerRef
                 completionBlock:(BNGReplaceOrdersCompletionBlock)completionBlock;

/**
 * Allows a client to update non-exposure changing fields.
 * @param marketId market on which to cancel the bet.
 * @param instructions collection of betting update instructions to execute on the market.
 * @param customerRef Optional parameter allowing the client to pass a unique string (up to 32 chars) that is used to de-dupe mistaken re-submissions.
 * @param completionBlock executed once the API call returns.
 */
+ (void)updateOrdersForMarketId:(NSString *)marketId
                   instructions:(NSArray *)instructions
                    customerRef:(NSString *)customerRef
                completionBlock:(BNGUpdateOrdersCompletionBlock)completionBlock;

#pragma mark Transformers

/**
 * Given an orderType NSString, this method returns the corresponding `BNGOrderType`
 * @param orderType NSString representation of a `BNGOrderType`
 * @return a `BNGOrderType` which corresponds to the orderType parameter.
 */
+ (BNGOrderType)orderTypeFromString:(NSString *)orderType;

/**
 * Given an `BNGOrderType` orderType, this method returns the corresponding NSString
 * @param orderType a 'BNGOrderType'
 * @return a NSString which corresponds to the orderType parameter.
 */
+ (NSString *)stringFromOrderType:(BNGOrderType)orderType;

/**
 * Given an persistenceType NSString, this method returns the corresponding `BNGPersistanceType`
 * @param persistenceType NSString representation of a `BNGOrderType`
 * @return a `BNGPersistanceType` which corresponds to the persistenceType parameter.
 */
+ (BNGPersistanceType)persistenceTypeFromString:(NSString *)persistenceType;

/**
 * Given an `BNGPersistanceType` orderType, this method returns the corresponding NSString
 * @param persistenceType a 'BNGPersistanceType'
 * @return a NSString which corresponds to the persistenceType parameter.
 */
+ (NSString *)stringFromPersistenceType:(BNGPersistanceType)persistenceType;

/**
 * Given an side NSString, this method returns the corresponding `BNGSide`
 * @param side NSString representation of a `BNGSide`
 * @return a `BNGSide` which corresponds to the side parameter.
 */
+ (BNGSide)sideFromString:(NSString *)side;

/**
 * Given an `BNGSide` side, this method returns the corresponding NSString
 * @param side a 'BNGSide'
 * @return a NSString which corresponds to the side parameter.
 */
+ (NSString *)stringFromSide:(BNGSide)side;

/**
 * Given an status NSString, this method returns the corresponding `BNGOrderStatus`
 * @param side NSString representation of a `BNGOrderStatus`
 * @return a `BNGOrderStatus` which corresponds to the status parameter.
 */
+ (BNGOrderStatus)orderStatusFromString:(NSString *)status;

/**
 * Given an `BNGOrderStatus` status, this method returns the corresponding NSString
 * @param status a 'BNGOrderStatus'
 * @return a NSString which corresponds to the status parameter.
 */
+ (NSString *)stringFromOrderStatus:(BNGOrderStatus)status;

/**
 * Given an `BNGOrderProjection` projection, this method returns the corresponding NSString
 * @param projection a 'BNGOrderProjection'
 * @return a NSString which corresponds to the projection parameter.
 */
+ (NSString *)stringFromOrderProjection:(BNGOrderProjection)projection;

@end
