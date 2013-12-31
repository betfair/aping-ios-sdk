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

#import "NSURL+APINGTests.h"

#import "NSURL+APING.h"

@implementation NSURL_APINGTests

- (void)testConstantsAreCorrect
{
    STAssertEqualObjects(BNGBettingOperation.cancelOrders,        @"cancelOrders",        @"BNGBettingOperation.cancelOrders == %@ (should be %@), BNGBettingOperationCancelOrders", @"cancelOrders");
    STAssertEqualObjects(BNGBettingOperation.listCompetitions,    @"listCompetitions",    @"BNGBettingOperation.listCompetitions == %@ (should be %@), BNGBettingOperationListCompetitions", @"listCompetitions");
    STAssertEqualObjects(BNGBettingOperation.listCountries,       @"listCountries",       @"BNGBettingOperation.listCountries == %@ (should be %@), BNGBettingOperationListCountries", @"listCountries");
    STAssertEqualObjects(BNGBettingOperation.listCurrentOrders,   @"listCurrentOrders",   @"BNGBettingOperation.listCurrentOrders == %@ (should be %@), BNGBettingOperationListCurrentOrders", @"listCurrentOrders");
    STAssertEqualObjects(BNGBettingOperation.listEvents,          @"listEvents",          @"BNGBettingOperation.listEvents == %@ (should be %@), BNGBettingOperationListEvents", @"listEvents");
    STAssertEqualObjects(BNGBettingOperation.listEventTypes,      @"listEventTypes",      @"BNGBettingOperation.listEventTypes == %@ (should be %@), BNGBettingOperationListEventTypes", @"listEventTypes");
    STAssertEqualObjects(BNGBettingOperation.listMarketBook,      @"listMarketBook",      @"BNGBettingOperation.listMarketBook == %@ (should be %@), BNGBettingOperationListMarketBook", @"listMarketBook");
    STAssertEqualObjects(BNGBettingOperation.listMarketCatalogue, @"listMarketCatalogue", @"BNGBettingOperation.listMarketCatalogue == %@ (should be %@), BNGBettingOperationListMarketCatalogue", @"listMarketCatalogue");
    STAssertEqualObjects(BNGBettingOperation.listMarketTypes,     @"listMarketTypes",     @"BNGBettingOperation.listMarketTypes == %@ (should be %@), BNGBettingOperationListMarketTypes", @"listMarketTypes");
    STAssertEqualObjects(BNGBettingOperation.listTimeRanges,      @"listTimeRanges",      @"BNGBettingOperation.listTimeRanges == %@ (should be %@), BNGBettingOperationListTimeRanges", @"listTimeRanges");
    STAssertEqualObjects(BNGBettingOperation.listVenues,          @"listVenues",          @"BNGBettingOperation.listVenues == %@ (should be %@), BNGBettingOperationListVenues", @"listVenues");
    STAssertEqualObjects(BNGBettingOperation.placeOrders,         @"placeOrders",         @"BNGBettingOperation.placeOrders == %@ (should be %@), BNGBettingOperationPlaceOrders", @"placeOrders");
    STAssertEqualObjects(BNGBettingOperation.replaceOrders,       @"replaceOrders",       @"BNGBettingOperation.replaceOrders == %@ (should be %@), BNGBettingOperationReplaceOrders", @"replaceOrders");
    STAssertEqualObjects(BNGBettingOperation.updateOrders,        @"updateOrders",        @"BNGBettingOperation.updateOrders == %@ (should be %@), BNGBettingOperationUpdateOrders", @"updateOrders");
}

- (void)testURLMatchesSuffix
{
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listEvents];
    
    STAssertTrue((BNGBettingOperation.listEvents.length > 0),
                 @"`BNGBettingOperation.listEvents` is %@.", (BNGBettingOperation.listEvents == nil) ? @"nil" : @"empty");
    
    STAssertTrue(([url.absoluteString rangeOfString:BNGBettingOperation.listEvents].location != NSNotFound),
                 @"The URL (%@) should have a suffix of %@.", url, BNGBettingOperation.listEvents);
}

- (void)testURLUsesBaseURL
{
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listEvents];
    
    STAssertTrue((BNGBaseURLString.length > 0),
                 @"BNGBaseURLString is %@.", (BNGBaseURLString == nil) ? @"nil" : @"empty");
    
    STAssertTrue(([url.absoluteString hasPrefix:BNGBaseURLString]),
                 @"The URL (%@) should have a prefix of %@.", url, BNGBaseURLString);
}

- (void)testURLContainsVersion
{
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listEvents];
    
    STAssertTrue((BNGAPIVersion.length > 0),
                 @"BNGAPIVersion is %@.", (BNGAPIVersion == nil) ? @"nil" : @"empty");
    
    STAssertTrue(([url.absoluteString rangeOfString:[NSString stringWithFormat:@"/v%@/", BNGAPIVersion]].location != NSNotFound),
                 @"The URL (%@) should contain the version (v%@).", url, BNGAPIVersion);
}

@end
