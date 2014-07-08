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

#import "BNGHeartbeat.h"
#import "APING.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGTestUtilities.h"

@interface BNGHeartbeatTest : XCTestCase

@end

@implementation BNGHeartbeatTest

- (void)testHeartbeatAPICall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGHeartbeat heartbeatForPreferredTimeSeconds:200 completionBlock:^(BNGHeartbeatReport *report, NSError *connectionError, BNGAPIError *apiError) {
        
        XCTAssertTrue(report.actionPerformed == BNGHeartBeatActionPerformedAllBetsCancelled, @"the action performed should indicate that all bets were cancelled");
        XCTAssertTrue(report.actualTimeoutSeconds == 200, @"the actualTimeoutSeconds should be set correctly in the response");
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testHeartbeatActionPerformedFromString
{
    XCTAssert([BNGHeartbeat heartbeatActionPerformedFromString:@"NONE"] == BNGHeartBeatActionPerformedNone, @"heartbeatActionPerformedFromString should return the appropriate BNGHeartBeatActionPerformed value for NONE");
    XCTAssert([BNGHeartbeat heartbeatActionPerformedFromString:@"CANCELLATION_REQUEST_SUBMITTED"] == BNGHeartBeatActionPerformedCancellationRequestSubmitted, @"heartbeatActionPerformedFromString should return the appropriate BNGHeartBeatActionPerformed value for CANCELLATION_REQUEST_SUBMITTED");
}

@end
