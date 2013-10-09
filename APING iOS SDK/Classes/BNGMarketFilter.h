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
// This product includes software developed by the <organization>.
// 4. Neither the name of the <organization> nor the
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

#import "BNGDictionaryRepresentation.h"

@class BNGTimeRange;

static const NSUInteger BNGMarketFilterNumberOfProperties = 15;

/**
 * Allows client code to filter out specific markets when executing searches.
 */
@interface BNGMarketFilter : NSObject <BNGDictionaryRepresentation>

@property (nonatomic, copy) NSString *textQuery;
@property (nonatomic, copy) NSArray *exchangeIds;
@property (nonatomic, copy) NSArray *eventTypeIds;
@property (nonatomic, copy) NSArray *eventIds;
@property (nonatomic, copy) NSArray *competitionIds;
@property (nonatomic, copy) NSArray *marketIds;
@property (nonatomic, copy) NSArray *venues;

/** BOOL */
@property (nonatomic, strong) NSNumber *bspOnly;

/** BOOL */
@property (nonatomic, strong) NSNumber *turnInPlayEnabled;

/** BOOL */
@property (nonatomic, strong) NSNumber *inPlayOnly;

@property (nonatomic, copy) NSArray *marketBettingTypes;
@property (nonatomic, copy) NSArray *marketCountries;
@property (nonatomic, copy) NSArray *marketTypeCodes;
@property (nonatomic, strong) BNGTimeRange *marketStartTime;
@property (nonatomic, copy) NSArray *withOrders;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NSString *key, id obj))block;

@end
