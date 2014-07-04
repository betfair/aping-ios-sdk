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

#import <XCTest/XCTest.h>

#import "BNGExecutionReport.h"

@interface BNGExecutionReportTest : XCTestCase

@end

@implementation BNGExecutionReportTest

- (void)testStringFromBNGExecutionReportStatus
{
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportStatus:BNGExecutionReportStatusSuccess] isEqualToString:@"SUCCESS"], @"stringFromBNGExecutionReportStatus should return the appropriate string for BNGExecutionReportStatusSuccess");
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportStatus:BNGExecutionReportStatusFailure] isEqualToString:@"FAILURE"], @"stringFromBNGExecutionReportStatus should return the appropriate string for BNGExecutionReportStatusFailure");
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportStatus:BNGExecutionReportStatusProcessedWithErrors] isEqualToString:@"PROCESSED_WITH_ERRORS"], @"stringFromBNGExecutionReportStatus should return the appropriate string for BNGExecutionReportStatusProcessedWithErrors");
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportStatus:BNGExecutionReportStatusTimeout] isEqualToString:@"TIMEOUT"], @"stringFromBNGExecutionReportStatus should return the appropriate string for BNGExecutionReportStatusTimeout");
}

- (void)testExecutionReportErrorCodeFromString
{
    XCTAssertTrue([BNGExecutionReport executionReportErrorCodeFromString:@"ERROR_IN_MATCHER"] == BNGExecutionReportErrorCodeErrorInMatcher, @"executionReportErrorCodeFromString should return the appropriate BNGExecutionReportErrorCode for `ERROR_IN_MATCHER`");
    XCTAssertTrue([BNGExecutionReport executionReportErrorCodeFromString:@"PROCESSED_WITH_ERRORS"] == BNGExecutionReportErrorCodeProcessedWithErrors, @"executionReportErrorCodeFromString should return the appropriate BNGExecutionReportErrorCode for `PROCESSED_WITH_ERRORS`");
    XCTAssertTrue([BNGExecutionReport executionReportErrorCodeFromString:@"INSUFFICIENT_FUNDS"] == BNGExecutionReportErrorCodeInsufficientFunds, @"executionReportErrorCodeFromString should return the appropriate BNGExecutionReportErrorCode for `INSUFFICIENT_FUNDS`");
}

- (void)testExecutionReportStatusFromString
{
    XCTAssertTrue([BNGExecutionReport executionReportStatusFromString:@"SUCCESS"] == BNGExecutionReportStatusSuccess, @"executionReportStatusFromString should return the appropriate BNGExecutionReportStatus for SUCCESS");
    XCTAssertTrue([BNGExecutionReport executionReportStatusFromString:@"FAILURE"] == BNGExecutionReportStatusFailure, @"executionReportStatusFromString should return the appropriate BNGExecutionReportStatus for FAILURE");
    XCTAssertTrue([BNGExecutionReport executionReportStatusFromString:@"PROCESSED_WITH_ERRORS"] == BNGExecutionReportStatusProcessedWithErrors, @"executionReportStatusFromString should return the appropriate BNGExecutionReportStatus for PROCESSED_WITH_ERRORS");
    XCTAssertTrue([BNGExecutionReport executionReportStatusFromString:@"TIMEOUT"] == BNGExecutionReportStatusTimeout, @"executionReportStatusFromString should return the appropriate BNGExecutionReportStatus for TIMEOUT");
}

- (void)testStringFromBNGExecutionReportErrorCode
{
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportErrorCode:BNGExecutionReportErrorCodeBetActionError] isEqualToString:@"BET_ACTION_ERROR"], @"stringFromBNGExecutionReportErrorCode should return the appropriate value for BET_ACTION_ERROR");
    XCTAssertTrue([[BNGExecutionReport stringFromBNGExecutionReportErrorCode:BNGExecutionReportErrorCodeDuplicateBetIds] isEqualToString:@"DUPLICATE_BET_IDS"], @"stringFromBNGExecutionReportErrorCode should return the appropriate value for DUPLICATE_BET_IDS");
}

@end
