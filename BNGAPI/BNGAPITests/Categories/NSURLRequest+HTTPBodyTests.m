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

#import "NSURLRequest+HTTPBody.h"

@interface NSURLRequest_HTTPBodyTests : XCTestCase

@end

@implementation NSURLRequest_HTTPBodyTests

- (void)testHTTPQueryParams
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.betfair.com?a=1&b=2"]];
    NSDictionary *queryParameters = request.httpQueryParams;
    
    XCTAssert(queryParameters[@"a"] != nil, @"The query string parameters should include a valud for a");
    XCTAssert(queryParameters[@"b"] != nil, @"The query string parameters should include a valud for a");
    XCTAssert(queryParameters[@"c"] == nil, @"The query string parameters should include a valud for a");
    
    XCTAssert([queryParameters[@"a"] isEqualToString:@"1"], @"The query string parameters should be set to the correct values");
    XCTAssert([queryParameters[@"b"] isEqualToString:@"2"], @"The query string parameters should be set to the correct values");
}

- (void)testHTTPBody
{
    NSMutableURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.betfair.com"]] mutableCopy];
    [request addBodyKey:@"a" value:@"1"];
    [request addBodyKey:@"b" value:@"2"];
    NSDictionary *bodyParmameters = request.httpBodyDictionary;
    
    XCTAssert([bodyParmameters[@"a"] isEqualToString:@"1"], @"httpBodyDictionary should have whatever parameters have been added via the addBodyKey method");
    XCTAssert([bodyParmameters[@"b"] isEqualToString:@"2"], @"httpBodyDictionary should have whatever parameters have been added via the addBodyKey method");
}

@end
