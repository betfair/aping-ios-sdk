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
// This product includes software developed by The Sporting Exchange Limited.
// 4. Neither the name of The Sporting Exchange Limited nor the
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

#import "BNGMutableURLRequestTests.h"

#import "BNGMutableURLRequest.h"
#import "APING.h"

@implementation BNGMutableURLRequestTests

- (void)testDefaultHeadersAutomaticallyAddedToRequest
{    
    BNGMutableURLRequest *request = [[BNGMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.betfair.com"]
                                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                                              timeoutInterval:30.0f];
    STAssertTrue([[request valueForHTTPHeaderField:BNGHTTPHeaderContentType] isEqualToString:BNGHTTPHeaderValueContentTypeDefault], @"Content-Type is not set as a default HTTP header");
    STAssertTrue([[request valueForHTTPHeaderField:BNGHTTPHeaderAccept] isEqualToString:BNGHTTPHeaderValueContentTypeDefault], @"Accept is not set as a default HTTP header");
    STAssertTrue([[request valueForHTTPHeaderField:BNGHTTPHeaderAcceptCharset] isEqualToString:BNGHTTPHeaderValueAcceptCharsetDefault], @"Accept-Charset is not set as a default HTTP header");
}

- (void)testDefaultParametersAutomaticallyAddedToRequest
{
    BNGMutableURLRequest *request = [[BNGMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.betfair.com"]
                                                                  cachePolicy:NSURLCacheStorageNotAllowed
                                                              timeoutInterval:30.0f];
    [request setPostParameters:@{@"one": @"two"}];
    NSString *body = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    STAssertTrue([body rangeOfString:[APING sharedInstance].locale].location != NSNotFound, @"Default locale should be added to the post body parameters");
    STAssertTrue([body rangeOfString:[APING sharedInstance].currencyCode].location != NSNotFound, @"Default currencyCode should be added to the post body parameters");
}

@end
