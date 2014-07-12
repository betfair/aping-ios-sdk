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

#import "NSURL+BNG.h"

const struct BNGLoginOperation BNGLoginOperation = {
    .login = @"login",
};

const struct BNGBettingOperation BNGBettingOperation = {
    .cancelOrders               = @"cancelOrders",
    .listCompetitions           = @"listCompetitions",
    .listCountries              = @"listCountries",
    .listCurrentOrders          = @"listCurrentOrders",
    .listEvents                 = @"listEvents",
    .listEventTypes             = @"listEventTypes",
    .listMarketBook             = @"listMarketBook",
    .listMarketCatalogue        = @"listMarketCatalogue",
    .listMarketTypes            = @"listMarketTypes",
    .listMarketProfitAndLoss    = @"listMarketProfitAndLoss",
    .listTimeRanges             = @"listTimeRanges", // not implemented yet
    .listVenues                 = @"listVenues",
    .placeOrders                = @"placeOrders",
    .replaceOrders              = @"replaceOrders", // not implemented yet
    .updateOrders               = @"updateOrders",
};

const struct BNGAccountOperation BNGAccountOperation = {
    .getAccountFunds   = @"getAccountFunds",
    .getAccountDetails = @"getAccountDetails",
};

NSString *const BNGBaseURLString        = @"https://api.betfair.com/exchange";
NSString *const BNGBaseLoginString      = @"https://identitysso.betfair.com";
NSString *const BNGAPIVersion           = @"1.0";
NSString *const BNGHeartbeatAPIVersion  = @"1";

@implementation NSURL (BNG)

+ (NSURL *)betfairNGLoginURLForOperation:(NSString *)operation
{
    NSParameterAssert(operation.length);
    
    if (operation.length) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@",
                                     BNGBaseLoginString,
                                     operation]];
    } else {
        return nil;
    }
}

+ (NSURL *)betfairNGBettingURLForOperation:(NSString *)operation
{
    NSParameterAssert(operation.length);
    
    if (operation.length) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/betting/rest/v%@/%@/",
                                     BNGBaseURLString,
                                     BNGAPIVersion,
                                     operation]];
    } else {
        return nil;
    }
}

+ (NSURL *)betfairNGAccountURLForOperation:(NSString *)operation
{
    NSParameterAssert(operation.length);
    
    if (operation.length) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/account/rest/v%@/%@/",
                                     BNGBaseURLString,
                                     BNGAPIVersion,
                                     operation]];
    } else {
        return nil;
    }
}

+ (NSURL *)betfairNGHeartbeatURL {
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/heartbeat/json-rpc/v%@",
                                 BNGBaseURLString,
                                 BNGHeartbeatAPIVersion]];
}

@end
