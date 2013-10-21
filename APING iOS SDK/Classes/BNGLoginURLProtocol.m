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

#import "BNGLoginURLProtocol.h"

#import "NSURLRequest+HTTPBody.h"
#import "NSURL+APING.h"

NSString * const BNGLoginURLProtocolDidLoginNotification    = @"BNGLoginURLProtocolDidLoginNotification";
NSString * const BNGLoginURLProtocolErrorKey                = @"BNGLoginURLProtocolErrorKey";
NSString * const BNGLoginURLProtocolHTTPBodyKey             = @"BNGLoginURLProtocolHTTPBodyKey";

static NSString *BFLoginURLScheme;

@implementation BNGLoginURLProtocol

+ (NSString *)registeredScheme
{
    return BFLoginURLScheme;
}

+ (void)registerWithScheme:(NSString *)scheme
{
    if (!BFLoginURLScheme) {
        [NSURLProtocol registerClass:self];
    }
    
    BFLoginURLScheme = [scheme copy];
}

+ (void)unregisterClass:(Class)protocolClass
{
    [super unregisterClass:protocolClass];
    BFLoginURLScheme = nil;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([request.URL.scheme isEqualToString:BFLoginURLScheme]) {
        
        return YES;
        
    } else if ([request.URL.absoluteString hasPrefix:[NSString stringWithFormat:@"%@/view/login", BNGBaseLoginString]]) {
        
        return (
                [request.httpBodyDictionary[@"errorCode"] isEqualToString:@"INVALID_USERNAME_OR_PASSWORD"] ||
                [request.httpQueryParams[@"errorCode"]    isEqualToString:@"INVALID_USERNAME_OR_PASSWORD"] ||
                [request.httpBodyDictionary[@"errorCode"] isEqualToString:@"PIN_DELETED"]                  ||
                [request.httpQueryParams[@"errorCode"]    isEqualToString:@"PIN_DELETED"]                  ||
                [request.httpBodyDictionary[@"errorCode"] isEqualToString:@"FORBIDDEN"]                    ||
                [request.httpQueryParams[@"errorCode"]    isEqualToString:@"FORBIDDEN"]
                );
    } else {
        return NO;
    }
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)aRequest toRequest:(NSURLRequest *)bRequest
{
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                        MIMEType:@"text/plain"
                                           expectedContentLength:0
                                                textEncodingName:@"UTF8"];

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    NSDictionary *bodyDictionary = self.request.httpBodyDictionary;
    userInfo[BNGLoginURLProtocolHTTPBodyKey] = bodyDictionary;
        
    if (bodyDictionary[@"errorCode"]) {
        userInfo[BNGLoginURLProtocolErrorKey] = [NSError errorWithDomain:bodyDictionary[@"errorCode"]
                                                                    code:BNGLoginUnknownErrorCode
                                                                userInfo:nil];
    } else {
        if (self.request.httpQueryParams[@"errorCode"]) {
            userInfo[BNGLoginURLProtocolErrorKey] = [NSError errorWithDomain:self.request.httpQueryParams[@"errorCode"]
                                                                        code:BNGLoginUnknownErrorCode
                                                                    userInfo:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BNGLoginURLProtocolDidLoginNotification
                                                        object:nil
                                                      userInfo:[userInfo copy]];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    [self.client URLProtocolDidFinishLoading:self];
}

@end