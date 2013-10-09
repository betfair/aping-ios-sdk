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

#import "BNGAccountTest.h"

#import "APING.h"

#import "BNGAccountFunds.h"
#import "BNGAccountDetails.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGTestUtilities.h"

@implementation BNGAccountTest

- (void)testAccountFundsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [BNGAccountFunds getAccountFundsWithCompletionBlock:^(BNGAccountFunds *accountFunds, NSError *connectionError, BNGAPIError *apiError) {

        STAssertTrue([accountFunds.availableToBetBalance isEqual:[NSDecimalNumber decimalNumberWithString:@"3.99"]], @"The available to bet balance should be equal to 3.99");
        STAssertTrue([accountFunds.exposure isEqual:[NSDecimalNumber decimalNumberWithString:@"-0.05"]], @"The exposure should be equal to -0.05");
        STAssertTrue([accountFunds.retainedCommission isEqual:[NSDecimalNumber zero]], @"The retained commission should be equal to 0.0");
        STAssertTrue([accountFunds.exposureLimit isEqual:[NSDecimalNumber decimalNumberWithString:@"-100"]], @"The exposure limit should be equal to -100.0");

        dispatch_semaphore_signal(semaphore);
        
    }];

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

- (void)testAccountDetailsApiCall
{
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];

    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [BNGAccountDetails getAccountDetailsWithCompletionBlock:^(BNGAccountDetails *accountDetails, NSError *connectionError, BNGAPIError *apiError) {

        STAssertTrue([accountDetails.currencyCode isEqualToString:@"GBP"], @"The currency code should be 'GBP'");
        STAssertTrue([accountDetails.firstName isEqualToString:@"Test "], @"The first name should be 'Test '");
        STAssertTrue([accountDetails.lastName isEqualToString:@"Account"], @"The last name should be 'Account'");
        STAssertTrue([accountDetails.localeCode isEqualToString:@"en"], @"The locale code should be 'en'");
        STAssertTrue([accountDetails.region isEqualToString:@"GBR"], @"The region should be 'GBR'");
        STAssertTrue([accountDetails.discountRate isEqual:[NSDecimalNumber zero]], @"The discount rate should be equal to 0.0");
        STAssertTrue(accountDetails.pointsBalance == 0, @"The points balance should be equal to 0");
        
        dispatch_semaphore_signal(semaphore);

    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

@end
