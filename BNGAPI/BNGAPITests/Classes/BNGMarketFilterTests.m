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

#import "BNGMarketFilter.h"

#import "BNGTimeRange.h"

@interface BNGMarketFilterTests : XCTestCase

@property (nonatomic) BNGMarketFilter *marketFilter;

@end

@implementation BNGMarketFilterTests

- (void)setUp
{
    self.marketFilter = [[BNGMarketFilter alloc] init];
}

- (void)tearDown
{
    self.marketFilter = nil;
}

- (void)testEmptyMarketFilterDictionaryRepresentation
{
    NSDictionary *dictionaryRepresentation = self.marketFilter.dictionaryRepresentation;
 
    XCTAssertNotNil(dictionaryRepresentation, @"dictionaryRepresentation is nil");
    XCTAssertTrue(dictionaryRepresentation.count == 1, @"dictionaryRepresentation is not empty: (%@)", dictionaryRepresentation);
}

- (void)testDictionaryRepresentationWithProperties
{
    id textQuery          = self.marketFilter.textQuery          = @"someTextQuery";
    id exchangeIds        = self.marketFilter.exchangeIds        = @[@"someExchangeIds"];
    id eventTypeIds       = self.marketFilter.eventTypeIds       = @[@"someEventTypeIds"];
    id eventIds           = self.marketFilter.eventIds           = @[@"someEventIds"];
    id competitionIds     = self.marketFilter.competitionIds     = @[@"someCompetitionIds"];
    id marketIds          = self.marketFilter.marketIds          = @[@"someMarketIds"];
    id venues             = self.marketFilter.venues             = @[@"someVenues"];
    id bspOnly            = self.marketFilter.bspOnly            = @YES;
    id turnInPlayEnabled  = self.marketFilter.turnInPlayEnabled  = @NO;
    id inPlayOnly         = self.marketFilter.inPlayOnly         = @YES;
    id marketBettingTypes = self.marketFilter.marketBettingTypes = @[@"someMarketBettingTypes"];
    id marketCountries    = self.marketFilter.marketCountries    = @[@"someMarketCountries"];
    id marketTypeCodes    = self.marketFilter.marketTypeCodes    = @[@"someMarketTypeCodes"];
    self.marketFilter.marketStartTime    = [[BNGTimeRange alloc] initWithDatesFrom:[NSDate date]
                                                                                to:[NSDate dateWithTimeIntervalSinceNow:1234]];
    id withOrders         = self.marketFilter.withOrders         = @[@"someWithOrders"];
    
    NSDictionary *dictionaryRepresentation = self.marketFilter.dictionaryRepresentation;
    
    XCTAssertEqualObjects(textQuery,          dictionaryRepresentation[@"filter"][@"textQuery"],          @"Error in `textQuery`: %@ != %@",          textQuery,          dictionaryRepresentation[@"filter"][@"textQuery"]);
    XCTAssertEqualObjects(exchangeIds,        dictionaryRepresentation[@"filter"][@"exchangeIds"],        @"Error in `exchangeIds`: %@ != %@",        exchangeIds,        dictionaryRepresentation[@"filter"][@"exchangeIds"]);
    XCTAssertEqualObjects(eventTypeIds,       dictionaryRepresentation[@"filter"][@"eventTypeIds"],       @"Error in `eventTypeIds`: %@ != %@",       eventTypeIds,       dictionaryRepresentation[@"filter"][@"eventTypeIds"]);
    XCTAssertEqualObjects(eventIds,           dictionaryRepresentation[@"filter"][@"eventIds"],           @"Error in `eventIds`: %@ != %@",           eventIds,           dictionaryRepresentation[@"filter"][@"eventIds"]);
    XCTAssertEqualObjects(competitionIds,     dictionaryRepresentation[@"filter"][@"competitionIds"],     @"Error in `competitionIds`: %@ != %@",     competitionIds,     dictionaryRepresentation[@"filter"][@"competitionIds"]);
    XCTAssertEqualObjects(marketIds,          dictionaryRepresentation[@"filter"][@"marketIds"],          @"Error in `marketIds`: %@ != %@",          marketIds,          dictionaryRepresentation[@"filter"][@"marketIds"]);
    XCTAssertEqualObjects(venues,             dictionaryRepresentation[@"filter"][@"venues"],             @"Error in `venues`: %@ != %@",             venues,             dictionaryRepresentation[@"filter"][@"venues"]);
    XCTAssertEqualObjects(bspOnly,            dictionaryRepresentation[@"filter"][@"bspOnly"],            @"Error in `bspOnly`: %@ != %@",            bspOnly,            dictionaryRepresentation[@"filter"][@"bspOnly"]);
    XCTAssertEqualObjects(turnInPlayEnabled,  dictionaryRepresentation[@"filter"][@"turnInPlayEnabled"],  @"Error in `turnInPlayEnabled`: %@ != %@",  turnInPlayEnabled,  dictionaryRepresentation[@"filter"][@"turnInPlayEnabled"]);
    XCTAssertEqualObjects(inPlayOnly,         dictionaryRepresentation[@"filter"][@"inPlayOnly"],         @"Error in `inPlayOnly`: %@ != %@",         inPlayOnly,         dictionaryRepresentation[@"filter"][@"inPlayOnly"]);
    XCTAssertEqualObjects(marketBettingTypes, dictionaryRepresentation[@"filter"][@"marketBettingTypes"], @"Error in `marketBettingTypes`: %@ != %@", marketBettingTypes, dictionaryRepresentation[@"filter"][@"marketBettingTypes"]);
    XCTAssertEqualObjects(marketCountries,    dictionaryRepresentation[@"filter"][@"marketCountries"],    @"Error in `marketCountries`: %@ != %@",    marketCountries,    dictionaryRepresentation[@"filter"][@"marketCountries"]);
    XCTAssertEqualObjects(marketTypeCodes,    dictionaryRepresentation[@"filter"][@"marketTypeCodes"],    @"Error in `marketTypeCodes`: %@ != %@",    marketTypeCodes,    dictionaryRepresentation[@"filter"][@"marketTypeCodes"]);
    XCTAssertEqualObjects(withOrders,         dictionaryRepresentation[@"filter"][@"withOrders"],         @"Error in `withOrders`: %@ != %@",         withOrders,         dictionaryRepresentation[@"filter"][@"withOrders"]);
    
    __block NSUInteger count = 0;
    [self.marketFilter enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj) {
        count++;
        
        XCTAssertEqualObjects(obj, dictionaryRepresentation[@"filter"][key], @"-enumerateKeysAndObjectsUsingBlock is returning wrong data");
    }];
}

@end
