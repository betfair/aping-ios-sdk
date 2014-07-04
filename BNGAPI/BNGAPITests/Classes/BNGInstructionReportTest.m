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

#import "BNGInstructionReport.h"

@interface BNGInstructionReportTest : XCTestCase

@end

@implementation BNGInstructionReportTest

- (void)testStringFromBNGInstructionReportStatus
{
    XCTAssertTrue([[BNGInstructionReport stringFromBNGInstructionReportStatus:BNGInstructionReportStatusSuccess] isEqualToString:@"SUCCESS"], @"stringFromBNGInstructionReportStatus should return the appropriate string for BNGInstructionReportStatusSuccess");
    XCTAssertTrue([[BNGInstructionReport stringFromBNGInstructionReportStatus:BNGInstructionReportStatusFailure] isEqualToString:@"FAILURE"], @"stringFromBNGInstructionReportStatus should return the appropriate string for BNGInstructionReportStatusFailure");
    XCTAssertTrue([[BNGInstructionReport stringFromBNGInstructionReportStatus:BNGInstructionReportStatusTimeout] isEqualToString:@"TIMEOUT"], @"stringFromBNGInstructionReportStatus should return the appropriate string for BNGInstructionReportStatusTimeout");
}

- (void)testInstructionReportStatusFromString
{
    XCTAssertTrue([BNGInstructionReport instructionReportStatusFromString:@"FAILURE"] == BNGInstructionReportStatusFailure, @"instructionReportStatusFromString should return the appropriate value for FAILURE");
    XCTAssertTrue([BNGInstructionReport instructionReportStatusFromString:@"SUCCESS"] == BNGInstructionReportStatusSuccess, @"instructionReportStatusFromString should return the appropriate value for SUCCESS");
    XCTAssertTrue([BNGInstructionReport instructionReportStatusFromString:@"TIMEOUT"] == BNGInstructionReportStatusTimeout, @"instructionReportStatusFromString should return the appropriate value for TIMEOUT");
}

- (void)testInstructionReportErrorCodeFromString
{
    XCTAssertTrue([BNGInstructionReport instructionReportErrorCodeFromString:@"INVALID_BET_SIZE"] == BNGInstructionReportErrorCodeInvalidBetSize, @"instructionReportErrorCodeFromString should return the correct BNGInstructionReportErrorCode for INVALID_BET_SIZE");
    XCTAssertTrue([BNGInstructionReport instructionReportErrorCodeFromString:@"INVALID_RUNNER"] == BNGInstructionReportErrorCodeInvalidRunner, @"instructionReportErrorCodeFromString should return the correct BNGInstructionReportErrorCode for INVALID_RUNNER");
}

- (void)testStringFromInstructionReportErrorCode
{
    XCTAssertTrue([[BNGInstructionReport stringFromBNGInstructionReportErrorCode:BNGInstructionReportErrorCodeInvalidBetSize] isEqualToString:@"INVALID_BET_SIZE"], @"stringFromBNGInstructionReportErrorCode should return the correct String for BNGInstructionReportErrorCodeInvalidBetSize");
    XCTAssertTrue([[BNGInstructionReport stringFromBNGInstructionReportErrorCode:BNGInstructionReportErrorCodeInvalidRunner] isEqualToString:@"INVALID_RUNNER"], @"stringFromBNGInstructionReportErrorCode should return the correct String for BNGInstructionReportErrorCodeInvalidRunner");
}

@end
