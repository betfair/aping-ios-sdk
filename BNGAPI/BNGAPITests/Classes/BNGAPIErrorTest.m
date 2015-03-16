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

#import "BNGAPIError.h"
#import "BNGAPIError_Private.h"

@interface BNGAPIErrorTest : XCTestCase

@end

@implementation BNGAPIErrorTest

- (void)testAPIErrorInitialisation
{
    BNGAPIError *error = [[BNGAPIError alloc] initWithDomain:@"domain" code:404 userInfo:@{@"error": @"details"}];
    
    XCTAssert([error.domain isEqualToString:@"domain"], @"the domain should be set for the error object");
    XCTAssert(error.code  == 404, @"the code should be set for the error object");
    XCTAssert([error.userInfo[@"error"] isEqualToString:@"details"], @"the code should be set for the error object");
}

- (void)testAPIErrorInitialisationAPISplashed
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://content.betfair.com/content/splash/unplanned/index.asp"] MIMEType:@"application/json" expectedContentLength:402 textEncodingName:@"UTF-8"];
    BNGAPIError *error = [[BNGAPIError alloc] initWithURLResponse:response];

    XCTAssert(error.code  == BNGAPIErrorCodeServiceBusy, @"the error code should be set to 'service busy' when the API is splashed");
}

- (void)testAPIErrorInitialisedUnexpectedError
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://identitysso.betfair.com"] MIMEType:@"application/json" expectedContentLength:402 textEncodingName:@"UTF-8"];
    BNGAPIError *error = [[BNGAPIError alloc] initWithURLResponse:response];
    
    XCTAssert(error.code  == BNGAPIErrorCodeUnexpectedError, @"the error code should be set to 'unexpected' when the API returns a generic error");
}

- (void)testAPIErrorInitialisationWithDictionary
{
    NSDictionary *dictionary = @{
        @"detail": @{
            @"APINGException": @{
                @"errorCode": @"INVALID_APP_KEY",
                @"errorDetails": @"The application key passed is invalid",
                @"requestUUID": @"prdang001-07021049-000afdf7a9"
            },
            @"exceptionname": @"APINGException"
        },
        @"faultcode": @"Client",
        @"faultstring": @"ANGX-0007"
        };
    
    BNGAPIError *error = [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:dictionary];
    
    XCTAssert([error.userInfo[@"faultcode"] isEqualToString:@"Client"], @"the userInfo dictionary should be equal to the raw response from the API server");
    XCTAssert([error.userInfo[@"faultstring"] isEqualToString:@"ANGX-0007"], @"the userInfo dictionary should be equal to the raw response from the API server");
}

- (void)testJSONRPCErrorInitialisationWithDictionary
{
    NSDictionary *dictionary = @{
                                 @"error": @{
                                         @"code": @"-32700",
                                         @"message": @"DSC-0008"
                                         },
                                 @"jsonrpc": @"2.0"
                                 };
    
    BNGAPIError *error = [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:dictionary];
    
    XCTAssert(error.code == -32700, @"the error's code should be set with the code returned from the API server");
}

- (void)testCougarAPIErrorCodes {
    
    NSDictionary *dictionary = @{
                                 @"error": @{
                                         @"code": @"-32700",
                                         @"message": @"DSC-0008"
                                         },
                                 @"jsonrpc": @"2.0"
                                 };
    
    BNGAPIError *error = [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:dictionary];
    
    XCTAssert(error.cougarErrorCode == BNGAPICougarErrorCodeJSONDeserialisationParseFailure, @"the error's code cougarErrorCode property should be set correctly");
}

@end
