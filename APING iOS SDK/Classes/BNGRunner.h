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

typedef NS_ENUM(NSInteger, BNGRunnerStatus) {
    BNGRunnerStatusUnknown,
    BNGRunnerStatusActive,
    BNGRunnerStatusWinner,
    BNGRunnerStatusLoser,
    BNGRunnerStatusRemovedVacant,
    BNGRunnerStatusRemoved
};

struct BNGRunnerMetadata {
    __unsafe_unretained NSString *adjustedRating;
    __unsafe_unretained NSString *age;
    __unsafe_unretained NSString *bred;
    __unsafe_unretained NSString *clothNumber;
    __unsafe_unretained NSString *coloursDescription;
    __unsafe_unretained NSString *coloursFilename;
    __unsafe_unretained NSString *colourType;
    __unsafe_unretained NSString *damsireBred;
    __unsafe_unretained NSString *damsireName;
    __unsafe_unretained NSString *damsireYearBorn;
    __unsafe_unretained NSString *damBred;
    __unsafe_unretained NSString *damName;
    __unsafe_unretained NSString *damYearBorn;
    __unsafe_unretained NSString *daysSinceLastRun;
    __unsafe_unretained NSString *forecasePriceDenominator;
    __unsafe_unretained NSString *forecasePriceNumerator;
    __unsafe_unretained NSString *form;
    __unsafe_unretained NSString *jockeyClaim;
    __unsafe_unretained NSString *jockeyName;
    __unsafe_unretained NSString *officialRating;
    __unsafe_unretained NSString *ownerName;
    __unsafe_unretained NSString *sexType;
    __unsafe_unretained NSString *sireBred;
    __unsafe_unretained NSString *sireName;
    __unsafe_unretained NSString *sireYearBorn;
    __unsafe_unretained NSString *stallDraw;
    __unsafe_unretained NSString *trainerName;
    __unsafe_unretained NSString *wearing;
    __unsafe_unretained NSString *weightUnits;
    __unsafe_unretained NSString *weightValue;
};

@class BNGExchangePrices;
@class BNGStartingPrices;

/**
 * Defines a competitor in a market.
 */
@interface BNGRunner : NSObject

/**
 * Unique identifier for the runner. Use this identifier when placing bets on specific runners.
 */
@property (nonatomic) long long selectionId;

/**
 * Unique identifier for a bettable outcome.
 */
@property (nonatomic) long long runnerId;

/**
 * Runners are usually displayed in a particular order in a market. This property dictates the
 * order in which a specific runner should appear in a market.
 */
@property (nonatomic) NSInteger sortPriority;
@property (nonatomic, strong) NSDecimalNumber *handicap;

/**
 * See the `BNGRunnerStatus` enum for details on this property.
 */
@property (nonatomic) BNGRunnerStatus status;
@property (nonatomic, strong) NSDecimalNumber *adjustmentFactor;

/**
 * Defines the last price at which this `BNGRunner` was matched.
 */
@property (nonatomic, strong) NSDecimalNumber *lastPriceTraded;

/**
 * Defines the amount matched on this particular `BNGRunner`.
 */
@property (nonatomic, strong) NSDecimalNumber *totalMatched;

/**
 * Only set should the `BNGRunner` be removed from the market.
 */
@property (nonatomic, strong) NSDate *removalDate;

/**
 * Auxiliary information for this `BNGRunner`. Some examples of metadata include the `BNGRunner`'s
 * horse racing information such as jockey name, silks etc. See `BNGRunnerMetadata` for
 * full details. Not every runner will have metadata associated with it.
 */
@property (nonatomic, copy) NSDictionary *metadata;

/**
 * Collection of `BNGOrder`s associated with this `BNGRunner`.
 */
@property (nonatomic, copy) NSArray *orders;
@property (nonatomic, copy) NSArray *matches;

/**
 * The exchange prices for this `BNGRunner`
 */
@property (nonatomic, strong) BNGExchangePrices *exchangePrices;

/**
 * The starting price prices for this `BNGRunner`
 */
@property (nonatomic, copy) BNGStartingPrices *startingPrices;

/**
 * Retrieve the full url for this `BNGRunner`'s silks. Only useful for horse racing `BNGRunner`s.
 * @return NSURL which points to this `BNGRunner`'s silks.
 */
- (NSURL *)runnerSilkUrl;

/**
 * Transformer for converting a NSString into a `BNGRunnerStatus`.
 * @param runnerStatus status string for a `BNGRunner`.
 * @return `BNGRunnerStatus` corresponding to the runnerStatus parameter.
 */
+ (BNGRunnerStatus)runnerStatusFromString:(NSString *)runnerStatus;

@end
