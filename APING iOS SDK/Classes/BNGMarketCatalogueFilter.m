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

#import "BNGMarketCatalogueFilter.h"

#import "BNGMarketCatalogue.h"

@implementation BNGMarketCatalogueFilter

- (id)init
{
    self = [super init];
    if (self) {
        // maxResults is a required parameter.
        _maxResults = @1;
        _marketProjection = @[
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionCompetition],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionEvent],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionEventType],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionMarketDescription],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionRunnerDescription],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionRunnerMetaData],
                              [BNGMarketCatalogue marketProjection:BNGMarketProjectionRunnerMarketStartTime],
        ];
    }
    return self;
}

#pragma mark - BNGDictionaryRepresentation

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj){
        dictionaryRepresentation[key] = obj;
    }];
    
    return @{@"filter": dictionaryRepresentation, @"maxResults": self.maxResults, @"marketProjection": self.marketProjection};
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"BNGMarketCatalogueFilter[textQuery, exchangeIds, eventTypeIds, eventIds, competitionIds, marketIds, venues, marketBettingTypes, marketCountries, marketTypeCodes, marketStartTime, withOrders, maxResults, marketProjection]: %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", self.textQuery, self.exchangeIds, self.eventTypeIds, self.eventIds, self.competitionIds, self.marketIds, self.venues, self.marketBettingTypes, self.marketCountries, self.marketTypeCodes, self.marketStartTime, self.withOrders, self.maxResults, self.marketProjection];
}

@end
