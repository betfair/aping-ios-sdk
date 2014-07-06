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

#import "BNGAccountDetails.h"

#import "APING.h"
#import "BNGAPIError_Private.h"
#import "BNGMutableURLRequest.h"
#import "NSURLConnection+BNGJSON.h"
#import "BNGAPIResponseParser.h"

@implementation BNGAccountDetails

#pragma mark API Calls

+ (void)getAccountDetailsWithCompletionBlock:(BNGAccountDetailsCompletionBlock)completionBlock
{
    NSParameterAssert(completionBlock);
    
    if (!completionBlock) return;
    
    NSURL *url = [NSURL betfairNGAccountURLForOperation:BNGAccountOperation.getAccountDetails];
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, [[BNGAPIError alloc] initWithURLResponse:response]);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       completionBlock([BNGAPIResponseParser parseBNGAccountDetailsFromResponse:JSONData], nil, nil);
                                   } else {
                                       BNGAPIError *error = [[BNGAPIError alloc] initWithDomain:BNGErrorDomain code:BNGErrorCodeNoData userInfo:nil];
                                       completionBlock(nil, connectionError, error);
                                   }
                               }];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [currencyCode: %@] [firstName: %@] [lastName: %@] [localeCode: %@] [region: %@] [discountRate: %@] [pointsBalance: %ld]",
            [super description],
            self.currencyCode,
            self.firstName,
            self.lastName,
            self.localeCode,
            self.region,
            self.discountRate,
            (long)self.pointsBalance];
}

@end
