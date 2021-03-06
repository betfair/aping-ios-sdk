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

#import "APING.h"
#import "BNGCompetition.h"
#import "BNGMarketFilter.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGTestUtilities.h"
#import "BNGCompetitionResult.h"

@interface BNGCompetitionTest : XCTestCase

@end

@implementation BNGCompetitionTest

- (void)testListCompetitions {
    
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGMarketFilter *marketFilter = [[BNGMarketFilter alloc] init];
    marketFilter.eventTypeIds = @[@(1)];
    
    [BNGCompetition listCompetitionsWithFilter:marketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
     
        int numberOfAsserts = 0;
        
        for (BNGCompetitionResult *competitionResult in results) {
            
            BNGCompetition *competition = competitionResult.competition;
            if ([competition.name isEqualToString:@"Russian Cup"]) {
                XCTAssert(competition.identifier == 33051, @"");
                numberOfAsserts++;
            } else if ([competition.name isEqualToString:@"W League Western Conference"]) {
                XCTAssert(competition.identifier == 3244079, @"");
                numberOfAsserts++;
            } else if ([competition.name isEqualToString:@"2014 Womens U20 World Championship"]) {
                XCTAssert(competition.identifier == 5517677, @"");
                numberOfAsserts++;
            }
        }
        
        XCTAssert(numberOfAsserts == 3, @"The test should have executed 3 separate asserts");
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
