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

#import "BNGCountryCode.h"

#import "APING.h"
#import "BNGAPIError_Private.h"
#import "BNGMutableURLRequest.h"
#import "NSURLConnection+BNGJSON.h"
#import "BNGAPIResponseParser.h"

@implementation BNGCountryCode

- (instancetype)initWithCountryCodeName:(NSString *)countryCode {
    
    self = [super init];
    
    if (self) {
        
        _countryCode = [countryCode copy];
    }
    
    return self;
}

+ (void)listCountriesWithFilter:(BNGMarketFilter *)marketFilter completionBlock:(BNGResultsCompletionBlock)completionBlock {
    
    NSParameterAssert(marketFilter);
    
    if (!marketFilter) return;
    
    NSURL *url = [NSURL betfairNGBettingURLForOperation:BNGBettingOperation.listCountries];
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [request setPostParameters:marketFilter.dictionaryRepresentation];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithURLResponse:response]);
                                   } else if ([JSONData isKindOfClass:[NSArray class]]) {
                                       completionBlock([BNGAPIResponseParser parseBNGCountryCodeResultsFromResponse:JSONData], connectionError, nil);
                                   } else {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithDomain:BNGErrorDomain code:BNGErrorCodeNoData userInfo:nil]);
                                   }
                               }];
}

@end
