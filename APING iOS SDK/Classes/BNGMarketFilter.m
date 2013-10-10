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

#import "BNGMarketFilter.h"

#import "BNGTimeRange.h"

@implementation BNGMarketFilter

#pragma mark - Enumeration

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NSString *key, id obj))block
{
    NSParameterAssert(block);
    
    if (self.textQuery)          block(@"textQuery",          self.textQuery);
    if (self.exchangeIds)        block(@"exchangeIds",        self.exchangeIds);
    if (self.eventTypeIds)       block(@"eventTypeIds",       self.eventTypeIds);
    if (self.eventIds)           block(@"eventIds",           self.eventIds);
    if (self.competitionIds)     block(@"competitionIds",     self.competitionIds);
    if (self.marketIds)          block(@"marketIds",          self.marketIds);
    if (self.venues)             block(@"venues",             self.venues);
    if (self.bspOnly)            block(@"bspOnly",            self.bspOnly);
    if (self.turnInPlayEnabled)  block(@"turnInPlayEnabled",  self.turnInPlayEnabled);
    if (self.inPlayOnly)         block(@"inPlayOnly",         self.inPlayOnly);
    if (self.marketBettingTypes) block(@"marketBettingTypes", self.marketBettingTypes);
    if (self.marketCountries)    block(@"marketCountries",    self.marketCountries);
    if (self.marketTypeCodes)    block(@"marketTypeCodes",    self.marketTypeCodes);
    if (self.withOrders)         block(@"withOrders",         self.withOrders);
    if (self.marketStartTime) {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        });
        
        if (self.marketStartTime.from) {
            block(@"marketStartingAfter", [dateFormatter stringFromDate:self.marketStartTime.from]);
        }
        
        if (self.marketStartTime.to) {
            block(@"marketStartingBefore", [dateFormatter stringFromDate:self.marketStartTime.to]);
        }
    }
}

#pragma mark - BNGDictionaryRepresentation

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] initWithCapacity:BNGMarketFilterNumberOfProperties];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj){
        dictionaryRepresentation[key] = obj;
    }];
    
    return @{@"filter": dictionaryRepresentation};
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"BNGMarketFilter[textQuery, exchangeIds, eventTypeIds, eventIds, competitionIds, marketIds, venues, marketBettingTypes, marketCountries, marketTypeCodes, marketStartTime, withOrders]: %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", self.textQuery, self.exchangeIds, self.eventTypeIds, self.eventIds, self.competitionIds, self.marketIds, self.venues, self.marketBettingTypes, self.marketCountries, self.marketTypeCodes, self.marketStartTime, self.withOrders];
}

@end
