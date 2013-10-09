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

#import "BNGOrder.h"

#import "APING.h"
#import "BNGAPIError_Private.h"
#import "BNGMutableURLRequest.h"
#import "NSURLConnection+BNGJSON.h"
#import "BNGTimeRange.h"
#import "BNGAPIResponseParser.h"
#import "BNGPlaceInstruction.h"
#import "BNGCancelInstruction.h"
#import "BNGReplaceInstruction.h"
#import "BNGUpdateInstruction.h"

struct BNGOrderParameters {
    __unsafe_unretained NSString *betIds;
    __unsafe_unretained NSString *marketIds;
    __unsafe_unretained NSString *orderProjection;
    __unsafe_unretained NSString *placedDateRange;
    __unsafe_unretained NSString *orderBy;
    __unsafe_unretained NSString *sortDir;
    __unsafe_unretained NSString *fromRecord;
    __unsafe_unretained NSString *toRecord;
    __unsafe_unretained NSString *from;
    __unsafe_unretained NSString *to;
};

struct BNGPlaceOrderParameters {
    __unsafe_unretained NSString *marketId;
    __unsafe_unretained NSString *instructions;
    __unsafe_unretained NSString *customerRef;
};

static const struct BNGOrderParameters BNGOrderParameters = {
    .betIds = @"betIds",
    .marketIds = @"marketIds",
    .orderProjection = @"orderProjection",
    .placedDateRange = @"placedDateRange",
    .orderBy = @"orderBy",
    .sortDir = @"sortDir",
    .fromRecord = @"fromRecord",
    .toRecord = @"toRecord",
    .from = @"from",
    .to = @"to",
};

static const struct BNGPlaceOrderParameters BNGPlaceOrderParameters = {
    .marketId = @"marketId",
    .instructions = @"instructions",
    .customerRef = @"customerRef",
};

@implementation BNGOrder

#pragma mark API Calls

+ (void)listCurrentOrdersWithCompletionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock
{
    [BNGOrder listCurrentOrdersForBetIds:nil marketIds:nil orderProjection:BNGOrderProjectionUnknown placedDateRange:nil orderBy:BNGOrderByUnknown sortDir:BNGOrderSortDirUnknown fromRecord:-1 toRecord:-1 completionBlock:completionBlock];
}

+ (void)listCurrentOrdersForBetIds:(NSArray *)betIds completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(betIds);
    
    if (!betIds.count) return;
    
    [BNGOrder listCurrentOrdersForBetIds:betIds marketIds:nil orderProjection:BNGOrderProjectionUnknown placedDateRange:nil orderBy:BNGOrderByUnknown sortDir:BNGOrderSortDirUnknown fromRecord:-1 toRecord:-1 completionBlock:completionBlock];
}

+ (void)listCurrentOrdersForMarketIds:(NSArray *)marketIds completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(marketIds);
    
    if (!marketIds.count) return;
    
    [BNGOrder listCurrentOrdersForBetIds:nil marketIds:marketIds orderProjection:BNGOrderProjectionUnknown placedDateRange:nil orderBy:BNGOrderByUnknown sortDir:BNGOrderSortDirUnknown fromRecord:-1 toRecord:-1 completionBlock:completionBlock];
}

+ (void)listCurrentOrdersForBetIds:(NSArray *)betIds
                         marketIds:(NSArray *)marketIds
                   orderProjection:(BNGOrderProjection)orderProjection
                   placedDateRange:(BNGTimeRange *)placedDateRange
                           orderBy:(BNGOrderBy)orderBy
                           sortDir:(BNGOrderSortDir)sortDir
                        fromRecord:(NSInteger)fromRecord
                          toRecord:(NSInteger)toRecord
                   completionBlock:(BNGCurrentOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    
    if (!completionBlock) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listCurrentOrders];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGOrder determinePostParametersForBetIds:betIds
                                                                marketIds:marketIds
                                                          orderProjection:orderProjection
                                                          placedDateRange:placedDateRange
                                                                  orderBy:orderBy
                                                                  sortDir:sortDir
                                                               fromRecord:fromRecord
                                                                 toRecord:toRecord]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       completionBlock([BNGAPIResponseParser parseBNGCurrentOrderSummaryReportFromResponse:JSONData], nil, nil);
                                   } else {
                                       NSError *error = [NSError errorWithDomain:APINGErrorDomain
                                                                            code:APINGErrorCodeNoData
                                                                        userInfo:nil];
                                       completionBlock(nil, error, nil);
                                   }
                               }];
}

+ (void)placeOrdersForMarketId:(NSString *)marketId
                  instructions:(NSArray *)instructions
                   customerRef:(NSString *)customerRef
               completionBlock:(BNGPlaceOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketId);
    NSParameterAssert(instructions.count);
    
    if (!completionBlock || !marketId || !instructions.count) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.placeOrders];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGOrder determinePlaceOrderPostParametersForMarketId:marketId
                                                                         instructions:instructions
                                                                          customerRef:customerRef]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       // first check to see that its not an error
                                       if (!JSONData[@"faultcode"] && !JSONData[@"faultstring"]) {
                                           completionBlock([BNGAPIResponseParser parseBNGPlaceExecutionReportFromResponse:JSONData], nil, nil);
                                       } else {
                                           completionBlock(nil, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData], nil);
                                       }
                                   } else {
                                       NSError *error = [NSError errorWithDomain:APINGErrorDomain
                                                                            code:APINGErrorCodeNoData
                                                                        userInfo:nil];
                                       completionBlock(nil, error, nil);
                                   }
                               }];
}

+ (void)cancelOrdersForMarketId:(NSString *)marketId
                   instructions:(NSArray *)instructions
                    customerRef:(NSString *)customerRef
                completionBlock:(BNGCancelOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketId);
    NSParameterAssert(instructions.count);
    
    if (!completionBlock || !marketId || !instructions.count) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.cancelOrders];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGOrder determineCancelOrderPostParametersForMarketId:marketId
                                                                          instructions:instructions
                                                                           customerRef:customerRef]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       // first check to see that its not an error
                                       if (!JSONData[@"faultcode"] && !JSONData[@"faultstring"]) {
                                           completionBlock([BNGAPIResponseParser parseBNGCancelExecutionReportFromResponse:JSONData], nil, nil);
                                       } else {
                                           completionBlock(nil, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData], nil);
                                       }
                                   } else {
                                       NSError *error = [NSError errorWithDomain:APINGErrorDomain
                                                                            code:APINGErrorCodeNoData
                                                                        userInfo:nil];
                                       completionBlock(nil, error, nil);
                                   }
                               }];
}

+ (void)replaceOrdersForMarketId:(NSString *)marketId
                    instructions:(NSArray *)instructions
                     customerRef:(NSString *)customerRef
                 completionBlock:(BNGReplaceOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketId);
    NSParameterAssert(instructions.count);
    
    if (!completionBlock || !marketId || !instructions.count) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.replaceOrders];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGOrder determineReplaceOrderPostParametersForMarketId:marketId
                                                                          instructions:instructions
                                                                           customerRef:customerRef]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       // first check to see that its not an error
                                       completionBlock([BNGAPIResponseParser parseBNGReplaceExecutionReportFromResponse:JSONData], nil, nil);
                                   } else {
                                       NSError *error = [NSError errorWithDomain:APINGErrorDomain
                                                                            code:APINGErrorCodeNoData
                                                                        userInfo:nil];
                                       completionBlock(nil, error, nil);
                                   }
                               }];
}

+ (void)updateOrdersForMarketId:(NSString *)marketId
                   instructions:(NSArray *)instructions
                    customerRef:(NSString *)customerRef
                completionBlock:(BNGUpdateOrdersCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(marketId);
    NSParameterAssert(instructions.count);
    
    if (!completionBlock || !marketId || !instructions.count) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.updateOrders];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:[BNGOrder determineUpdateOrderPostParametersForMarketId:marketId
                                                                          instructions:instructions
                                                                           customerRef:customerRef]];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       // first check to see that its not an error
                                       completionBlock([BNGAPIResponseParser parseBNGUpdateExecutionReportFromResponse:JSONData], nil, nil);
                                   } else {
                                       NSError *error = [NSError errorWithDomain:APINGErrorDomain
                                                                            code:APINGErrorCodeNoData
                                                                        userInfo:nil];
                                       completionBlock(nil, error, nil);
                                   }
                               }];
}

#pragma mark Transformers

+ (BNGOrderType)orderTypeFromString:(NSString *)orderType
{
    BNGOrderType type = BNGOrderTypeLimitUnknown;
    NSString *orderTypeUppercase = [orderType uppercaseString];
    if ([orderTypeUppercase isEqualToString:@"LIMIT"]) {
        type = BNGOrderTypeLimit;
    } else if ([orderTypeUppercase isEqualToString:@"LIMIT_ON_CLOSE"]) {
        type = BNGOrderTypeLimitOnClose;
    } else if ([orderTypeUppercase isEqualToString:@"MARKET_ON_CLOSE"]) {
        type = BNGOrderTypeMarketOnClose;
    }
    return type;
}

+ (NSString *)stringFromOrderType:(BNGOrderType)orderType
{
    NSString *orderTypeString = @"UNKNOWN";
    switch (orderType) {
        case BNGOrderTypeLimit:
            orderTypeString = @"LIMIT";
            break;
        case BNGOrderTypeLimitOnClose:
            orderTypeString = @"LIMIT_ON_CLOSE";
            break;
        case BNGOrderTypeMarketOnClose:
            orderTypeString = @"MARKET_ON_CLOSE";
            break;
        default:
            break;
    }
    return orderTypeString;
}

+ (BNGPersistanceType)persistenceTypeFromString:(NSString *)persistenceType
{
    BNGPersistanceType type = BNGPersistanceTypeUnknown;
    NSString *persistenceTypeUppercase = [persistenceType uppercaseString];
    if ([persistenceTypeUppercase isEqualToString:@"LAPSE"]) {
        type = BNGPersistanceTypeLapse;
    } else if ([persistenceTypeUppercase isEqualToString:@"PERSIST"]) {
        type = BNGPersistanceTypePersist;
    } else if ([persistenceTypeUppercase isEqualToString:@"MARKET_ON_CLOSE"]) {
        type = BNGPersistanceTypeMarketOnClose;
    }    
    return type;
}

+ (NSString *)stringFromPersistenceType:(BNGPersistanceType)persistenceType
{
    NSString *type = @"UNKNOWN";
    switch (persistenceType) {
        case BNGPersistanceTypeLapse:
            type = @"LAPSE";
            break;
        case BNGPersistanceTypeMarketOnClose:
            type = @"MARKET_ON_CLOSE";
            break;
        case BNGPersistanceTypePersist:
            type = @"PERSIST";
            break;
        default:
            break;
    }
    return type;
}

+ (BNGSide)sideFromString:(NSString *)side
{
    BNGSide type = BNGSideUnknown;
    NSString *sideUppercase = [side uppercaseString];
    if ([sideUppercase isEqualToString:@"BACK"]) {
        type = BNGSideBack;
    } else if ([sideUppercase isEqualToString:@"LAY"]) {
        type = BNGSideLay;
    }
    return type;
}

+ (NSString *)stringFromSide:(BNGSide)side
{
    NSString *sideString = @"UNKNOWN";
    switch (side) {
        case BNGSideBack:
            sideString = @"BACK";
            break;
        case BNGSideLay:
            sideString = @"LAY";
            break;
        default:
            break;
    }
    return sideString;
}

+ (BNGOrderStatus)orderStatusFromString:(NSString *)status
{
    BNGOrderStatus orderStatus = BNGOrderStatusUnknown;
    NSString *statusUppercase = [status uppercaseString];
    if ([statusUppercase isEqualToString:@"EXECUTION_COMPLETE"]) {
        orderStatus = BNGOrderStatusExecutionComplete;
    } else if ([statusUppercase isEqualToString:@"EXECUTABLE"]) {
        orderStatus = BNGOrderStatusExecutable;
    }
    return orderStatus;
}

+ (NSString *)stringFromOrderStatus:(BNGOrderStatus)status
{
    NSString *statusString = @"UNKNOWN";
    switch (status) {
        case BNGOrderStatusExecutable:
            statusString = @"EXECUTABLE";
            break;
        case BNGOrderStatusExecutionComplete:
            statusString = @"EXECUTION_COMPLETE";
            break;
        default:
            break;
    }
    return statusString;
}

+ (NSString *)stringFromOrderProjection:(BNGOrderProjection)projection
{
    NSString *orderProjection = @"UNKNOWN";
    switch (projection) {
        case BNGOrderProjectionAll:
            orderProjection = @"ALL";
            break;
        case BNGOrderProjectionExecutable:
            orderProjection = @"EXECUTABLE";
            break;
        case BNGOrderProjectionExecutionComplete:
            orderProjection = @"EXECUTION_COMPLETE";
            break;
        default:
            break;
    }
    return orderProjection;
}

+ (NSString *)stringFromOrderBy:(BNGOrderBy)orderBy
{
    NSString *orderByString = @"UNKNOWN";
    switch (orderBy) {
        case BNGOrderByBet:
            orderByString = @"BY_BET";
            break;
        case BNGOrderByMarket:
            orderByString = @"BY_MARKET";
            break;
        default:
            break;
    }
    return orderByString;
}

+ (NSString *)stringFromSortDir:(BNGOrderSortDir)sortDir
{
    NSString *sortDirString = @"UNKNOWN";
    switch (sortDir) {
        case BNGOrderSortDirEarliestToLatest:
            sortDirString = @"EARLIEST_TO_LATEST";
            break;
        case BNGOrderSortDirLatestToEarliest:
            sortDirString = @"LATEST_TO_EARLIEST";
            break;
        default:
            break;
    }
    return sortDirString;
}

#pragma mark POST Request Parameters

+ (NSDictionary *)determinePostParametersForBetIds:(NSArray *)betIds
                                         marketIds:(NSArray *)marketIds
                                   orderProjection:(BNGOrderProjection)orderProjection
                                   placedDateRange:(BNGTimeRange *)placedDateRange
                                           orderBy:(BNGOrderBy)orderBy
                                           sortDir:(BNGOrderSortDir)sortDir
                                        fromRecord:(NSInteger)fromRecord
                                          toRecord:(NSInteger)toRecord
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:8];
    if (betIds.count) {
        parameters[BNGOrderParameters.betIds] = betIds;
    }
    if (marketIds.count) {
        parameters[BNGOrderParameters.marketIds] = marketIds;
    }
    if (orderProjection != BNGOrderProjectionUnknown) {
        parameters[BNGOrderParameters.orderProjection] = [BNGOrder stringFromOrderProjection:orderProjection];
    }
    if (placedDateRange) {
        parameters[BNGOrderParameters.placedDateRange] = placedDateRange.dictionaryRepresentation;
    }
    if (orderBy != BNGOrderByUnknown) {
        parameters[BNGOrderParameters.orderBy] = [BNGOrder stringFromOrderBy:orderBy];
    }
    if (sortDir != BNGOrderSortDirUnknown) {
        parameters[BNGOrderParameters.sortDir] = [BNGOrder stringFromSortDir:sortDir];
    }
    if (fromRecord > 0) {
        parameters[BNGOrderParameters.fromRecord] = @(fromRecord);
    }
    if (toRecord > 0) {
        parameters[BNGOrderParameters.toRecord] = @(toRecord);
    }
    return [parameters copy];
}

+ (NSDictionary *)determinePlaceOrderPostParametersForMarketId:(NSString *)marketId
                                                  instructions:(NSArray *)instructions
                                                   customerRef:(NSString *)customerRef
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[BNGPlaceOrderParameters.marketId] = marketId;
    parameters[BNGPlaceOrderParameters.instructions] = [BNGPlaceInstruction dictionaryRepresentationsForBNGPlaceInstructions:instructions];
    if (customerRef) {
        parameters[BNGPlaceOrderParameters.customerRef] = customerRef;
    }
    return [parameters copy];
}

+ (NSDictionary *)determineCancelOrderPostParametersForMarketId:(NSString *)marketId
                                                   instructions:(NSArray *)instructions
                                                    customerRef:(NSString *)customerRef
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[BNGPlaceOrderParameters.marketId] = marketId;
    parameters[BNGPlaceOrderParameters.instructions] = [BNGCancelInstruction dictionaryRepresentationsForBNGCancelInstructions:instructions];
    if (customerRef) {
        parameters[BNGPlaceOrderParameters.customerRef] = customerRef;
    }
    return [parameters copy];
}

+ (NSDictionary *)determineReplaceOrderPostParametersForMarketId:(NSString *)marketId
                                                    instructions:(NSArray *)instructions
                                                     customerRef:(NSString *)customerRef
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[BNGPlaceOrderParameters.marketId] = marketId;
    parameters[BNGPlaceOrderParameters.instructions] = [BNGReplaceInstruction dictionaryRepresentationsForBNGReplaceInstructions:instructions];
    if (customerRef) {
        parameters[BNGPlaceOrderParameters.customerRef] = customerRef;
    }
    return [parameters copy];
}

+ (NSDictionary *)determineUpdateOrderPostParametersForMarketId:(NSString *)marketId
                                                   instructions:(NSArray *)instructions
                                                    customerRef:(NSString *)customerRef
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[BNGPlaceOrderParameters.marketId] = marketId;
    parameters[BNGPlaceOrderParameters.instructions] = [BNGUpdateInstruction dictionaryRepresentationsForBNGUpdateInstructions:instructions];
    if (customerRef) {
        parameters[BNGPlaceOrderParameters.customerRef] = customerRef;
    }
    return [parameters copy];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"BNGOrder[betId, marketId, selectionId, orderType, status, side, priceSize]: %@ %@ %lld %@ %@ %@ %@", self.betId, self.marketId, self.selectionId, [BNGOrder stringFromOrderType:self.orderType], [BNGOrder stringFromOrderStatus:self.status], [BNGOrder stringFromSide:self.side], self.priceSize];
}

@end
