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

#import "BNGURLProtocolResourceLoader.h"

static NSDictionary *responses;

@implementation BNGURLProtocolResourceLoader

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (!responses) {
        responses = @{
            @"https://api.betfair.com/exchange/betting/rest/v1.0/listEvents/": @"events.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/listEventTypes/": @"event_types.json",
            @"https://api.betfair.com/exchange/account/rest/v1.0/getAccountFunds": @"account_funds.json",
            @"https://api.betfair.com/exchange/account/rest/v1.0/getAccountDetails": @"account_details.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/listMarketBook/": @"market_book.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/listMarketCatalogue/": @"market_catalogue.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/listCurrentOrders/": @"current_orders.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/placeOrders/": @"place_order.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/replaceOrders/": @"replace_order.json",
            @"https://api.betfair.com/exchange/betting/rest/v1.0/updateOrders/": @"update_order.json",
            };
    }
//    return NO;
    return responses[request.URL.absoluteString] != nil;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (NSCachedURLResponse *)cachedResponse
{
	return nil;
}

- (void)startLoading
{
    NSString *fileName = responses[self.request.URL.absoluteString];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]]];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                        MIMEType:@"text/json"
                                           expectedContentLength:data.length
                                                textEncodingName:@"UTF8"];
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{    
    [self.client URLProtocolDidFinishLoading:self];
}

@end
