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

#import "BNGMarketCatalogueDescription.h"

@interface BNGMarketCatalogueDescriptionTest : XCTestCase

@end

@implementation BNGMarketCatalogueDescriptionTest

- (void)testMarketBettingTypeFromString
{
    XCTAssertTrue([BNGMarketCatalogueDescription marketBettingTypeFromString:@"LINE"] == BNGMarketBettingTypeLine, @"marketBettingTypeFromString should return the appropriate BNGMarketBettingType for LINE");
    XCTAssertTrue([BNGMarketCatalogueDescription marketBettingTypeFromString:@"RANGE"] == BNGMarketBettingTypeRange, @"marketBettingTypeFromString should return the appropriate BNGMarketBettingType for RANGE");
    XCTAssertTrue([BNGMarketCatalogueDescription marketBettingTypeFromString:@"ASIAN_HANDICAP_DOUBLE_LINE"] == BNGMarketBettingTypeAsianHandicapDoubleLine, @"marketBettingTypeFromString should return the appropriate BNGMarketBettingType for ASIAN_HANDICAP_DOUBLE_LINE");
    XCTAssertTrue([BNGMarketCatalogueDescription marketBettingTypeFromString:@"ASIAN_HANDICAP_SINGLE_LINE"] == BNGMarketBettingTypeAsianHandicapSingleLine, @"marketBettingTypeFromString should return the appropriate BNGMarketBettingType for ASIAN_HANDICAP_SINGLE_LINE");
    XCTAssertTrue([BNGMarketCatalogueDescription marketBettingTypeFromString:@"FIXED_ODDS"] == BNGMarketBettingTypeFixedOdds, @"marketBettingTypeFromString should return the appropriate BNGMarketBettingType for FIXED_ODDS");
}

- (void)testStringFromBNGMarketType
{
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeOdds] isEqualToString:@"ODDS"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeOdds");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeLine] isEqualToString:@"LINE"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeLine");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeRange] isEqualToString:@"RANGE"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeRange");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeAsianHandicapDoubleLine] isEqualToString:@"ASIAN_HANDICAP_DOUBLE_LINE"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeAsianHandicapDoubleLine");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeAsianHandicapSingleLine] isEqualToString:@"ASIAN_HANDICAP_SINGLE_LINE"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeAsianHandicapSingleLine");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketBettingType:BNGMarketBettingTypeFixedOdds] isEqualToString:@"FIXED_ODDS"], @"stringFromMarketBettingType should return the appropriate String for BNGMarketBettingTypeFixedOdds");
}

- (void)testStringFromMarketType
{
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketType:BNGMarketTypeMatchOdds] isEqualToString:@"MATCH_ODDS"], @"stringFromMarketType should return the appropriate String for BNGMarketTypeMatchOdds");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketType:BNGMarketTypeAsianHandicap] isEqualToString:@"ASIAN_HANDICAP"], @"stringFromMarketType should return the appropriate String for BNGMarketTypeAsianHandicap");
    XCTAssertTrue([[BNGMarketCatalogueDescription stringFromMarketType:BNGMarketTypeUndifferentiated] isEqualToString:@"UNDIFFERENTIATED"], @"stringFromMarketType should return the appropriate String for BNGMarketTypeUndifferentiated");
}

@end
