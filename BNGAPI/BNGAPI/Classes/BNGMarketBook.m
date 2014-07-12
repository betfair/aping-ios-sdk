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

#import "BNGMarketBook.h"

#import "BNGOrder.h"

#import "APING.h"
#import "BNGAPIError_Private.h"
#import "BNGMutableURLRequest.h"
#import "NSURLConnection+BNGJSON.h"
#import "BNGAPIResponseParser.h"
#import "BNGPriceProjection.h"

@implementation BNGMarketBook

#pragma mark API calls

+ (void)listMarketBooksForMarketIds:(NSArray *)marketIds
                    priceProjection:(BNGPriceProjection *)priceProjection
                    completionBlock:(BNGResultsCompletionBlock)completionBlock
{
    // delegate directly to the fully fledged API call with two unknown parameters.
    [BNGMarketBook listMarketBooksForMarketIds:marketIds
                               priceProjection:priceProjection
                               orderProjection:BNGOrderProjectionUnknown
                               matchProjection:BNGMatchProjectionUnknown completionBlock:completionBlock];
}

+ (void)listMarketBooksForMarketIds:(NSArray *)marketIds
                    priceProjection:(BNGPriceProjection *)priceProjection
                    orderProjection:(BNGOrderProjection)orderProjection
                    matchProjection:(BNGMatchProjection)matchProjection
                    completionBlock:(BNGResultsCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketIds && marketIds.count);
    NSParameterAssert(priceProjection);
    
    if (!completionBlock || !marketIds || !marketIds.count || !priceProjection) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listMarketBook];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGMarketBook determinePostParametersForMarketIds:marketIds
                                                                  priceProjection:priceProjection
                                                                  orderProjection:orderProjection
                                                                  matchProjection:matchProjection]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithURLResponse:response]);
                                   } else if ([JSONData isKindOfClass:[NSArray class]]) {
                                       NSArray *jsonArray = (NSArray *)JSONData;
                                       if (jsonArray.count) {
                                           completionBlock([BNGAPIResponseParser parseBNGMarketBooksFromResponse:JSONData], connectionError, nil);
                                       } else {
                                           completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData]);
                                       }
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData]);
                                   } else {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithDomain:BNGErrorDomain code:BNGErrorCodeNoData userInfo:nil]);
                                   }
                               }];
}

+ (void)listMarketProfitAndLossForMarketIds:(NSSet *)marketIds
                         includeSettledBets:(BOOL)includeSettledBets
                             includeBspBets:(BOOL)includeBspBets
                            netOfCommission:(BOOL)netOfCommission
                            completionBlock:(BNGResultsCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketIds && marketIds.count);
    
    if (!completionBlock || !marketIds || !marketIds.count) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listMarketBook];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGMarketBook determinePostParametersForMarketIds:marketIds
                                                               includeSettledBets:includeSettledBets
                                                                   includeBspBets:includeBspBets
                                                                  netOfCommission:netOfCommission]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithURLResponse:response]);
                                   } else if ([JSONData isKindOfClass:[NSArray class]]) {
                                       NSArray *jsonArray = (NSArray *)JSONData;
                                       if (jsonArray.count) {
                                           completionBlock([BNGAPIResponseParser parseBNGMarketProfitAndLossesFromResponse:JSONData], connectionError, nil);
                                       } else {
                                           completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData]);
                                       }
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData]);
                                   } else {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithDomain:BNGErrorDomain code:BNGErrorCodeNoData userInfo:nil]);
                                   }
                               }];
}

+ (NSDictionary *)determinePostParametersForMarketIds:(NSArray *)marketIds
                                      priceProjection:(BNGPriceProjection *)priceProjection
                                      orderProjection:(BNGOrderProjection)orderProjection
                                      matchProjection:(BNGMatchProjection)matchProjection
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"marketIds"] = marketIds;
    parameters[@"priceProjection"] = priceProjection.dictionaryRepresentation;
    if (orderProjection != BNGOrderProjectionUnknown) {
        parameters[@"orderProjection"] = [BNGOrder stringFromOrderProjection:orderProjection];
    }
    if (matchProjection != BNGMatchProjectionUnknown) {
        parameters[@"matchProjection"] = [BNGMarketBook stringFromMatchProjection:matchProjection];
    }
    return [parameters copy];
}

+ (NSDictionary *)determinePostParametersForMarketIds:(NSSet *)marketIds
                                   includeSettledBets:(BOOL)includeSettledBets
                                       includeBspBets:(BOOL)includeBspBets
                                      netOfCommission:(BOOL)netOfCommission
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"marketIds"] = marketIds;
    parameters[@"includeSettledBets"] = @(includeSettledBets);
    parameters[@"includeBspBets"] = @(includeBspBets);
    parameters[@"netOfCommission"] = @(netOfCommission);
    return [parameters copy];
}

+ (BNGMarketStatus)marketStatusFromString:(NSString *)marketStatus
{
    BNGMarketStatus status = BNGMarketStatusUnknown;
    NSString *uppercaseMarketStatus = [marketStatus uppercaseString];
    static NSDictionary *marketStatusDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marketStatusDictionary = @{
                                   @"INACTIVE":     @(BNGMarketStatusInactive),
                                   @"OPEN":         @(BNGMarketStatusOpen),
                                   @"SUSPENDED":    @(BNGMarketStatusSuspended),
                                   @"CLOSED":       @(BNGMarketStatusClosed),
                                   };
    });
    if (marketStatusDictionary[uppercaseMarketStatus]) {
        status = [marketStatusDictionary[uppercaseMarketStatus] integerValue];
    }
    return status;
}

+ (NSString *)stringFromMatchProjection:(BNGMatchProjection)matchProjection
{
    NSString *projection = @"UNKNOWN";
    switch (matchProjection) {
        case BNGMatchProjectionNoRollup: {
            projection = @"NO_ROLLUP";
        } break;
        case BNGMatchProjectionRolledUpByAvgPrice: {
            projection = @"ROLLED_UP_BY_AVG_PRICE";
        } break;
        case BNGMatchProjectionRolledUpByPrice: {
            projection = @"ROLLED_UP_BY_PRICE";
        } break;
        default:
            break;
    }
    return projection;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [marketId: %@] [status: %ld] [numberOfWinners: %ld] [numberOfRunners: %ld] [numberOfActiveRunners: %ld] [runners: %@]",
            [super description],
            self.marketId,
            (long)self.status,
            (long)self.numberOfWinners,
            (long)self.numberOfRunners,
            (long)self.numberOfActiveRunners,
            self.runners];
}

@end
