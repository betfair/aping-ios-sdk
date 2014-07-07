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

#import <Foundation/Foundation.h>

#import "NSURL+BNG.h"
#import "BNGMarketFilter.h"

/**
 * A `BNGCountryCode` is a unique identifier for a country in which a market/event/competition is happening. Not all markets/events/competitions have country codes associated with them.
 */
@interface BNGCountryCode : NSObject

/**
 * Uniquely identifies this country. See http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 for details.
 */
@property (nonatomic, copy) NSString *countryCode;

/**
 * Simple initialiser for `BNGCountryCode`
 * @param countryCode the name of the country code associated with this `BNGCountryCode`
 * @return an instance of `BNGCountryCode`
 */
- (instancetype)initWithCountryCodeName:(NSString *)countryCode;

/**
 * Given a BNGMarketFilter, this method finds a list of http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 ISO country codes.
 * @param marketFilter used to filter out certain types of country codes from the response
 * @param completionBlock executed once the API call returns.
 */
+ (void)listCountriesWithFilter:(BNGMarketFilter *)marketFilter completionBlock:(BNGResultsCompletionBlock)completionBlock;

@end
