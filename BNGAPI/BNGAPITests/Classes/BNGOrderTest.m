// Copyright (c) 2013 - 2015 The Sporting Exchange Limited
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

#import <XCTest/XCTest.h>

#import "BNGOrder.h"
#import "BNGLimitOrder.h"
#import "APING.h"
#import "BNGPriceSize.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGCurrentOrderSummaryReport.h"
#import "BNGPlaceExecutionReport.h"
#import "BNGPlaceInstruction.h"
#import "BNGCancelInstruction.h"
#import "BNGReplaceInstruction.h"
#import "BNGTestUtilities.h"
#import "BNGPlaceInstructionReport.h"
#import "BNGCancelExecutionReport.h"
#import "NSString+RandomCustomerReferenceId.h"
#import "BNGPlaceInstruction.h"
#import "BNGReplaceExecutionReport.h"
#import "BNGReplaceInstructionReport.h"
#import "BNGReplaceInstruction.h"
#import "BNGCancelInstructionReport.h"
#import "BNGUpdateExecutionReport.h"
#import "BNGUpdateInstruction.h"
#import "BNGUpdateInstructionReport.h"

@interface BNGOrderTest : XCTestCase

@end

@interface BNGOrder ()

+ (NSString *)stringFromOrderBy:(BNGOrderBy)orderBy;
+ (NSString *)stringFromSortDir:(BNGOrderSortDir)sortDir;

@end

@implementation BNGOrderTest

- (void)testCurrentOrdersApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGOrder listCurrentOrdersWithCompletionBlock:^(BNGCurrentOrderSummaryReport *report, NSError *connectionError, BNGAPIError *apiError) {

        XCTAssertFalse(report.moreAvailable, @"There should not be any more orders available for this request");
        XCTAssertTrue(report.currentOrders.count, @"There should be 5 current orders available for this request");
        for (BNGOrder *order in report.currentOrders) {
            if ([order.betId isEqualToString:@"28764485239"]) {
                XCTAssertTrue([order.marketId isEqualToString:@"1.109165222"], @"The market id should be equal to 1.109165222 for the order with bet id 28764485239");
                XCTAssertTrue(order.selectionId == 55190, @"The selection id should be equal to 55190 for the order with bet id 28764485239");
                XCTAssertTrue(order.side == BNGSideBack, @"The BNGOrder should be marked as a back bet for the order with bet id 28764485239");
                XCTAssertTrue(order.status == BNGOrderStatusExecutionComplete, @"The status should be marked as complete for the order with bet id 28764485239");
                XCTAssertTrue(order.persistenceType == BNGPersistanceTypeLapse, @"The persistenceType should be marked as 'LAPSE' for the order with bet id 28764485239");
                XCTAssertTrue([order.avgPriceMatched isEqual:[NSDecimalNumber decimalNumberWithString:@"3.35"]], @"The average price matched for the order with bet id 28764485239 should be 3.35");
            }
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testCurrentOrdersForBetsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGOrder listCurrentOrdersForBetIds:@[@"123"] completionBlock:^(BNGCurrentOrderSummaryReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        XCTAssertFalse(report.moreAvailable, @"There should not be any more orders available for this request");
        XCTAssertTrue(report.currentOrders.count, @"There should be 5 current orders available for this request");
        for (BNGOrder *order in report.currentOrders) {
            if ([order.betId isEqualToString:@"28764485239"]) {
                XCTAssertTrue([order.marketId isEqualToString:@"1.109165222"], @"The market id should be equal to 1.109165222 for the order with bet id 28764485239");
                XCTAssertTrue(order.selectionId == 55190, @"The selection id should be equal to 55190 for the order with bet id 28764485239");
                XCTAssertTrue(order.side == BNGSideBack, @"The BNGOrder should be marked as a back bet for the order with bet id 28764485239");
                XCTAssertTrue(order.status == BNGOrderStatusExecutionComplete, @"The status should be marked as complete for the order with bet id 28764485239");
                XCTAssertTrue(order.persistenceType == BNGPersistanceTypeLapse, @"The persistenceType should be marked as 'LAPSE' for the order with bet id 28764485239");
                XCTAssertTrue([order.avgPriceMatched isEqual:[NSDecimalNumber decimalNumberWithString:@"3.35"]], @"The average price matched for the order with bet id 28764485239 should be 3.35");
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testCurrentOrdersForMarketIdsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGOrder listCurrentOrdersForMarketIds:@[@"1.1234567"] completionBlock:^(BNGCurrentOrderSummaryReport *report, NSError *connectionError, BNGAPIError *apiError) {
       
        XCTAssertFalse(report.moreAvailable, @"There should not be any more orders available for this request");
        XCTAssertTrue(report.currentOrders.count, @"There should be 5 current orders available for this request");
        for (BNGOrder *order in report.currentOrders) {
            if ([order.betId isEqualToString:@"28764485239"]) {
                XCTAssertTrue([order.marketId isEqualToString:@"1.109165222"], @"The market id should be equal to 1.109165222 for the order with bet id 28764485239");
                XCTAssertTrue(order.selectionId == 55190, @"The selection id should be equal to 55190 for the order with bet id 28764485239");
                XCTAssertTrue(order.side == BNGSideBack, @"The BNGOrder should be marked as a back bet for the order with bet id 28764485239");
                XCTAssertTrue(order.status == BNGOrderStatusExecutionComplete, @"The status should be marked as complete for the order with bet id 28764485239");
                XCTAssertTrue(order.persistenceType == BNGPersistanceTypeLapse, @"The persistenceType should be marked as 'LAPSE' for the order with bet id 28764485239");
                XCTAssertTrue([order.avgPriceMatched isEqual:[NSDecimalNumber decimalNumberWithString:@"3.35"]], @"The average price matched for the order with bet id 28764485239 should be 3.35");
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testPlaceOrdersApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGLimitOrder *order = [[BNGLimitOrder alloc] init];
    order.priceSize = [[BNGPriceSize alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:@"100"] size:[NSDecimalNumber decimalNumberWithString:@"2"]];
    order.selectionId = 55190;
    order.persistenceType = BNGPersistanceTypeLapse;
    
    BNGPlaceInstruction *placeOrder = [[BNGPlaceInstruction alloc] init];
    placeOrder.selectionId = 55190;
    placeOrder.limitOrder = order;
    placeOrder.side = BNGSideBack;
    placeOrder.orderType = BNGOrderTypeLimit;
    
    [BNGOrder placeOrdersForMarketId:@"1.110515784" instructions:@[placeOrder] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGPlaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {

        XCTAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this place bet request.");
        XCTAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this place bet request");
        BNGPlaceInstructionReport *instructionReport = report.instructionReports[0];
        BNGPlaceInstruction *placeInstruction = instructionReport.instruction;
        XCTAssertTrue(placeInstruction.selectionId == 55190, @"The runner id in the bet placement request should be echoed back in the bet place response");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testReplaceOrderApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGReplaceInstruction *replaceInstruction = [[BNGReplaceInstruction alloc] initWithBetId:@"29370326195" newPrice:[NSDecimalNumber decimalNumberWithString:@"3"]];
    
    [BNGOrder replaceOrdersForMarketId:@"1.109165222" instructions:@[replaceInstruction] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGReplaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        XCTAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this replace bet request.");
        XCTAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this replace bet request");
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testCancelOrderApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGCancelInstruction *instruction = [[BNGCancelInstruction alloc] initWithBetId:@"1234" sizeReduction:[NSDecimalNumber decimalNumberWithString:@"2"]];
    
    [BNGOrder cancelOrdersForMarketId:@"1.109165222" instructions:@[instruction] customerRef:@"123" completionBlock:^(BNGCancelExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        XCTAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this cancel bet request.");
        XCTAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this cancel bet request");
        
        BNGCancelInstructionReport *cancelInstructionReport = report.instructionReports[0];
        XCTAssertTrue([[cancelInstructionReport.sizeCancelled stringValue] isEqualToString:@"2"], @"The size cancelled should be 2");
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testUpdateOrderApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGUpdateInstruction *instruction = [[BNGUpdateInstruction alloc] initWithBetId:@"123" newPersistanceType:BNGPersistanceTypePersist];
    
    [BNGOrder updateOrdersForMarketId:@"1.114084208" instructions:@[instruction] customerRef:@"123" completionBlock:^(BNGUpdateExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        XCTAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this update bet request.");
        XCTAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this update bet request");
        
        BNGUpdateInstructionReport *updateInstructionReport = report.instructionReports[0];
        
        XCTAssertTrue(updateInstructionReport.updateInstruction.persistenceType == BNGPersistanceTypePersist, @"The persistence type of the updated bet should be `BNGPersistanceTypePersist`");
        XCTAssertTrue([updateInstructionReport.updateInstruction.betId longLongValue] == 39047245474, @"The bet id of the updated bet should be parsed correctly");
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testStringFromOrderStatus
{
    XCTAssertTrue([[BNGOrder stringFromOrderStatus:BNGOrderStatusExecutable] isEqualToString:@"EXECUTABLE"], @"The stringFromOrderStatus should return the appropriate string for BNGOrderStatusExecutable");
    XCTAssertTrue([[BNGOrder stringFromOrderStatus:BNGOrderStatusExecutionComplete] isEqualToString:@"EXECUTION_COMPLETE"], @"The stringFromOrderStatus should return the appropriate string for BNGOrderStatusExecutionComplete");
}

- (void)testStringFromOrderProjection
{
    XCTAssertTrue([[BNGOrder stringFromOrderProjection:BNGOrderProjectionAll] isEqualToString:@"ALL"], @"The stringFromOrderProjection should return the appropriate string for BNGOrderProjectionAll");
    XCTAssertTrue([[BNGOrder stringFromOrderProjection:BNGOrderProjectionExecutable] isEqualToString:@"EXECUTABLE"], @"The stringFromOrderProjection should return the appropriate string for BNGOrderProjectionExecutable");
    XCTAssertTrue([[BNGOrder stringFromOrderProjection:BNGOrderProjectionExecutionComplete] isEqualToString:@"EXECUTION_COMPLETE"], @"The stringFromOrderProjection should return the appropriate string for BNGOrderProjectionExecutionComplete");
}

- (void)testStringFromOrderType
{
    XCTAssertTrue([[BNGOrder stringFromOrderType:BNGOrderTypeLimitOnClose] isEqualToString:@"LIMIT_ON_CLOSE"], @"The stringFromOrderType should return the appropriate string for BNGOrderTypeLimitOnClose");
    XCTAssertTrue([[BNGOrder stringFromOrderType:BNGOrderTypeMarketOnClose] isEqualToString:@"MARKET_ON_CLOSE"], @"The stringFromOrderType should return the appropriate string for BNGOrderTypeMarketOnClose");
}

- (void)testOrderTypeFromString
{
    BNGOrderType limitOnCloseOrderType = [BNGOrder orderTypeFromString:@"LIMIT_ON_CLOSE"];
    BNGOrderType marketOnCloseOrderType = [BNGOrder orderTypeFromString:@"MARKET_ON_CLOSE"];
    XCTAssertTrue(limitOnCloseOrderType == BNGOrderTypeLimitOnClose, @"The orderTypeFromString method should return the appropriate BNGOrderType for LIMIT_ON_CLOSE");
    XCTAssertTrue(marketOnCloseOrderType == BNGOrderTypeMarketOnClose, @"The orderTypeFromString method should return the appropriate BNGOrderType for MARKET_ON_CLOSE");
}

- (void)testStringFromSide
{
    XCTAssertTrue([[BNGOrder stringFromSide:BNGSideBack] isEqualToString:@"BACK"], @"The stringFromSide method should return the appropriate BNGSide for BACK");
    XCTAssertTrue([[BNGOrder stringFromSide:BNGSideLay] isEqualToString:@"LAY"], @"The stringFromSide method should return the appropriate BNGSide for LAY");
}

- (void)testStringFromOrderBy
{
    XCTAssertTrue([[BNGOrder stringFromOrderBy:BNGOrderByBet] isEqualToString:@"BY_BET"], @"The stringFromOrderBy method should return the appropriate string for BNGOrderByBet");
    XCTAssertTrue([[BNGOrder stringFromOrderBy:BNGOrderByMarket] isEqualToString:@"BY_MARKET"], @"The stringFromOrderBy method should return the appropriate string for BNGOrderByMarket");
}

- (void)testPersistenceTypeFromString
{
    XCTAssertTrue([BNGOrder persistenceTypeFromString:@"LAPSE"] == BNGPersistanceTypeLapse, @"The persistenceTypeFromString method should return the appropriate BNGPersistenceType for LAPSE");
    XCTAssertTrue([BNGOrder persistenceTypeFromString:@"MARKET_ON_CLOSE"] == BNGPersistanceTypeMarketOnClose, @"The persistenceTypeFromString method should return the appropriate BNGPersistenceType for MARKET_ON_CLOSE");
    XCTAssertTrue([BNGOrder persistenceTypeFromString:@"PERSIST"] == BNGPersistanceTypePersist, @"The persistenceTypeFromString method should return the appropriate BNGPersistenceType for PERSIST");
}

- (void)testStringFromPersistenceType
{
    XCTAssertTrue([[BNGOrder stringFromPersistenceType:BNGPersistanceTypeLapse] isEqualToString:@"LAPSE"], @"The stringFromPersistenceType method should return the appropriate string");
    XCTAssertTrue([[BNGOrder stringFromPersistenceType:BNGPersistanceTypeMarketOnClose] isEqualToString:@"MARKET_ON_CLOSE"], @"The stringFromPersistenceType method should return the appropriate string");
    XCTAssertTrue([[BNGOrder stringFromPersistenceType:BNGPersistanceTypePersist] isEqualToString:@"PERSIST"], @"The stringFromPersistenceType method should return the appropriate string");
}

- (void)testOrderStatusFromString
{
    XCTAssertTrue([BNGOrder orderStatusFromString:@"EXECUTION_COMPLETE"] == BNGOrderStatusExecutionComplete, @"The orderStatusFromString method should return the appropriate value for EXECUTION_COMPLETE");
    XCTAssertTrue([BNGOrder orderStatusFromString:@"EXECUTABLE"] == BNGOrderStatusExecutable, @"The orderStatusFromString method should return the appropriate value for EXECUTABLE");
}

- (void)testStringFromSortDir
{
    XCTAssertTrue([[BNGOrder stringFromSortDir:BNGOrderSortDirEarliestToLatest] isEqualToString:@"EARLIEST_TO_LATEST"], @"The stringFromSortDir method should return the appropriate string for BNGOrderSortDirEarliestToLatest");
    XCTAssertTrue([[BNGOrder stringFromSortDir:BNGOrderSortDirLatestToEarliest] isEqualToString:@"LATEST_TO_EARLIEST"], @"The stringFromSortDir method should return the appropriate string for BNGOrderSortDirLatestToEarliest");
}

@end
