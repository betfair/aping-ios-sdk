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

typedef NS_ENUM(NSInteger, BNGMarketProjection) {
    BNGMarketProjectionUnknown,
    BNGMarketProjectionCompetition,
    BNGMarketProjectionEvent,
    BNGMarketProjectionEventType,
    BNGMarketProjectionMarketDescription,
    BNGMarketProjectionRunnerDescription,
    BNGMarketProjectionRunnerMetaData,
    BNGMarketProjectionRunnerMarketStartTime,
};

#import "NSURL+APING.h"

@class BNGMarketFilter;
@class BNGCompetition;
@class BNGEvent;
@class BNGEventType;
@class BNGMarketCatalogueFilter;
@class BNGMarketCatalogueDescription;

/**
 * Has all the information you need to know about a market.
 */
@interface BNGMarketCatalogue : NSObject

/**
 * `BNGCompetition` associated with this `BNGMarketCatalogue`. Not every `BNGMarketCatalogue`
 * will have this property set.
 */
@property (nonatomic, strong) BNGCompetition *competition;

/**
 * Ancillary information for this `BNGMarketCatalogue`.
 */
@property (nonatomic, strong) BNGMarketCatalogueDescription *description;

/**
 * `BNGEvent` associated with this `BNGMarketCatalogue`.
 */
@property (nonatomic, strong) BNGEvent *event;

/**
 * Type of event that this `BNGMarketCatalogue` is associated with.
 */
@property (nonatomic, strong) BNGEventType *eventType;

/**
 * Unique identifier for this market.
 */
@property (nonatomic, copy) NSString *marketId;

/**
 * Name for this `BNGMarketCatalogue`.
 */
@property (nonatomic, copy) NSString *marketName;

/**
 * When does this `BNGMarketCatalogue` start officially.
 */
@property (nonatomic, strong) NSDate *marketStartTime;

/**
 * Collection of `BNGRunner`s associated with this market.
 */
@property (nonatomic, copy) NSArray *runners;

/**
 * Given a BNGMarketFilter, this method finds a list of BNGMarketCatalogues.
 * @param marketCatalogueFilter used to filter out certain types of BNGMarketCatalogues from the response
 * @param completionBlock executed once the API call returns.
 */
+ (void)listMarketCataloguesWithFilter:(BNGMarketCatalogueFilter *)marketCatalogueFilter completionBlock:(BNGResultsCompletionBlock)completionBlock;

/**
 * Given an `BNGMarketProjection` projection, this method returns the corresponding NSString
 * @param projection a 'BNGMarketProjection'
 * @return a NSString which corresponds to the projection parameter.
 */
+ (NSString *)marketProjection:(BNGMarketProjection)projection;

@end
