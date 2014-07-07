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

@class BNGMarketFilter;

/**
 * A venue represents a place where an event/market is taking place. Currently, only Horse Racing markets have venues associated with them (i.e. Cheltenham, Ascot).
 */
@interface BNGVenue : NSObject

/**
 * The human-readable name for this venue.
 */
@property (nonatomic, copy) NSString *venueName;

#pragma mark Initialisation

/**
 * Simple initialiser which takes in the venueName
 * @param venueName the name by which this venue is humanly identifiable
 * @return an instance of `BNGVenue`
 */
- (instancetype)initWithVenueName:(NSString *)venueName;

#pragma mark API Calls

/**
 * Allows a client to request all the known venues with a specific filter.
 * @param marketFilter allows client code to filter out specific venues from the response.
 * @param completionBlock executed once the API call returns.
 */
+ (void)venuesWithFilter:(BNGMarketFilter *)marketFilter
         completionBlock:(BNGResultsCompletionBlock)completionBlock;

@end
