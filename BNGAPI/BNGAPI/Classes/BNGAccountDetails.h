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

#import "NSURL+BNG.h"

/**
 * Contains details on a user's account. Does NOT contain any wallet/funds information.
 */
@interface BNGAccountDetails : NSObject

/**
 * Currency code associated with this `BNGAccountDetails`. @see `BNGSupportedCurrencyCodes` for details.
 */
@property (nonatomic, copy) NSString *currencyCode;

/**
 * This user's first name.
 */
@property (nonatomic, copy) NSString *firstName;

/**
 * This user's last name.
 */
@property (nonatomic, copy) NSString *lastName;

/**
 * Locale associated with this `BNGAccountDetails`. @see `BNGSupportedLocales` for details.
 */
@property (nonatomic, copy) NSString *localeCode;

/**
 * Defines where this user is located.
 */
@property (nonatomic, copy) NSString *region;

/**
 * Timezone associated with this `BNGAccountDetails`
 */
@property (nonatomic) NSTimeZone *timezone;

/**
 * Determines whether there is any discount associated with this `BNGAccountDetails`
 */
@property (nonatomic) NSDecimalNumber *discountRate;

/**
 * How many points are associated with this `BNGAccountDetails`
 */
@property (nonatomic) NSInteger pointsBalance;

/**
 * Retrieves the account details for the currently authenticated user.
 * @param completionBlock executed once the API call returns.
 */
+ (void)getAccountDetailsWithCompletionBlock:(BNGAccountDetailsCompletionBlock)completionBlock;

@end
