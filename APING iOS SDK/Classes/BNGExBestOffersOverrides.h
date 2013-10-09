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

#pragma mark Enums

typedef NS_ENUM(NSInteger, BNGRollupModel) {
    BNGRollupModelUnknown,
    BNGRollupModelStake,
    BNGRollupModelPayout,
    BNGRollupModelManagedLiability,
    BNGRollupModelNone
};

#import "BNGDictionaryRepresentation.h"

/**
 * When making a `listMarketBook` API call, this class can be used to get the exact prices that you want.
 */
@interface BNGExBestOffersOverrides : NSObject<BNGDictionaryRepresentation>

/**
 * Dictates how many prices you want to receive back in the response.
 */
@property (nonatomic) NSInteger bestPricesDepth;

/**
 * The `BNGRollupModel` to use when requesting the BNGMarketBook. If unspecified defaults to `BNGRollupModelStake`
 * rollup model with rollupLimit of minimum stake in the specified currency.
 */
@property (nonatomic) BNGRollupModel rollupModel;

/**
 * The volume limit to use when rolling up returned sizes. The exact definition of the limit depends on the
 * `BNGRollupModel`. If no limit is provided it will use minimum stake as default the value.
 */
@property (nonatomic) NSInteger rollupLimit;

/**
 * Not supported as yet.
 */
@property (nonatomic, strong) NSDecimalNumber *rollupLiabilityThreshold;

/**
 * Not supported as yet.
 */
@property (nonatomic) NSInteger rollupLiabilityFactor;

/**
 * Given an `BNGRollupModel` rollupModel, this method returns the corresponding NSString
 * @param rollupModel a 'BNGRollupModel'
 * @return a NSString which corresponds to the rollupModel parameter.
 */
+ (NSString *)stringFromRollupModel:(BNGRollupModel)rollupModel;

@end
