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

#import "BNGOrderTest.h"

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

@implementation BNGOrderTest

- (void)testCurrentOrdersApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGOrder listCurrentOrdersWithCompletionBlock:^(BNGCurrentOrderSummaryReport *report, NSError *connectionError, BNGAPIError *apiError) {

        STAssertFalse(report.moreAvailable, @"There should not be any more orders available for this request");
        STAssertTrue(report.currentOrders.count, @"There should be 5 current orders available for this request");
        for (BNGOrder *order in report.currentOrders) {
            if ([order.betId isEqualToString:@"28764485239"]) {
                STAssertTrue([order.marketId isEqualToString:@"1.109165222"], @"The market id should be equal to 1.109165222 for the order with bet id 28764485239");
                STAssertTrue(order.selectionId == 55190, @"The selection id should be equal to 55190 for the order with bet id 28764485239");
                STAssertTrue(order.side == BNGSideBack, @"The BNGOrder should be marked as a back bet for the order with bet id 28764485239");
                STAssertTrue(order.status == BNGOrderStatusExecutionComplete, @"The status should be marked as complete for the order with bet id 28764485239");
                STAssertTrue(order.persistenceType == BNGPersistanceTypeLapse, @"The persistenceType should be marked as 'LAPSE' for the order with bet id 28764485239");
                STAssertTrue([order.avgPriceMatched isEqual:[NSDecimalNumber decimalNumberWithString:@"3.35"]], @"The average price matched for the order with bet id 28764485239 should be 3.35");
            }
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
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

        STAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this place bet request.");
        STAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this place bet request");
        BNGPlaceInstructionReport *instructionReport = report.instructionReports[0];
        BNGPlaceInstruction *placeInstruction = instructionReport.instruction;
        STAssertTrue(placeInstruction.selectionId == 55190, @"The runner id in the bet placement request should be echoed back in the bet place response");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

- (void)testReplaceOrderApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGReplaceInstruction *replaceInstruction = [[BNGReplaceInstruction alloc] initWithBetId:@"29370326195" newPrice:[NSDecimalNumber decimalNumberWithString:@"3"]];
    
    [BNGOrder replaceOrdersForMarketId:@"1.109165222" instructions:@[replaceInstruction] customerRef:[NSString randomCustomerReferenceId] completionBlock:^(BNGReplaceExecutionReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        STAssertTrue(report.instructionReports.count, @"There should be at least one instruction report available for this replace bet request.");
        STAssertTrue(report.errorCode == BNGExecutionReportErrorCodeUnknown, @"There should be no error code associated with this replace bet request");
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

@end
