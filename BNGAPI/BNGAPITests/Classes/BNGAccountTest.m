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

#import "BNGAccountFunds.h"
#import "BNGAccountDetails.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGTestUtilities.h"
#import "BNGAccount.h"

@interface BNGAccountTest : XCTestCase

@end

@implementation BNGAccountTest

- (void)testAccountFundsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [BNGAccountFunds getAccountFundsWithCompletionBlock:^(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError) {

        XCTAssertTrue([accountFunds.availableToBetBalance isEqual:[NSDecimalNumber decimalNumberWithString:@"3.99"]], @"The available to bet balance should be equal to 3.99");
        XCTAssertTrue([accountFunds.exposure isEqual:[NSDecimalNumber decimalNumberWithString:@"-0.05"]], @"The exposure should be equal to -0.05");
        XCTAssertTrue([accountFunds.retainedCommission isEqual:[NSDecimalNumber zero]], @"The retained commission should be equal to 0.0");
        XCTAssertTrue([accountFunds.exposureLimit isEqual:[NSDecimalNumber decimalNumberWithString:@"-100"]], @"The exposure limit should be equal to -100.0");

        dispatch_semaphore_signal(semaphore);
        
    }];

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testAccountDetailsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];

    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGAccountDetails getAccountDetailsWithCompletionBlock:^(BNGAccountDetails *accountDetails, NSError *connectionError, BNGAPIError *apiError) {

        XCTAssertTrue([accountDetails.currencyCode isEqualToString:@"GBP"], @"The currency code should be 'GBP'");
        XCTAssertTrue([accountDetails.firstName isEqualToString:@"Test "], @"The first name should be 'Test '");
        XCTAssertTrue([accountDetails.lastName isEqualToString:@"Account"], @"The last name should be 'Account'");
        XCTAssertTrue([accountDetails.localeCode isEqualToString:@"en"], @"The locale code should be 'en'");
        XCTAssertTrue([accountDetails.region isEqualToString:@"GBR"], @"The region should be 'GBR'");
        XCTAssertTrue([accountDetails.discountRate isEqual:[NSDecimalNumber zero]], @"The discount rate should be equal to 0.0");
        XCTAssertTrue(accountDetails.pointsBalance == 0, @"The points balance should be equal to 0");
        
        dispatch_semaphore_signal(semaphore);

    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testLoginWithUserName
{
    BNGMutableURLRequest *request = [BNGAccount loginWithUserName:@"username" password:@"password" product:@"product" redirectUrl:@"redirect_url" completionBlock:^(NSString *ssoKey, NSError *connectionError, BNGAPIError *apiError) {
        
    }];
    
    XCTAssertTrue([request.HTTPMethod isEqualToString:@"POST"], @"loginWithUserName should be executed over POST");
    NSString *dataInStringFormat = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([dataInStringFormat isEqualToString:@"username=username&password=password&applicationId=product&url=redirect_url&product=product&redirectMethod=POST"], @"");
}

@end
