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

#import "BNGExBestOffersOverrides.h"

@implementation BNGExBestOffersOverrides

#pragma mark - BNGDictionaryRepresentation

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
    if (self.rollupModel) {
        dictionaryRepresentation[@"rollupModel"] = [BNGExBestOffersOverrides stringFromRollupModel:self.rollupModel];
    }
    if (self.rollupLimit) {
        dictionaryRepresentation[@"rollupLimit"] = @(self.rollupLimit);
    }
    if (self.bestPricesDepth) {
        dictionaryRepresentation[@"bestPricesDepth"] = @(self.bestPricesDepth);
    }
    if (self.rollupModel == BNGRollupModelManagedLiability) {
        if (self.rollupLiabilityFactor) {
            dictionaryRepresentation[@"rollupLiabilityFactor"] = @(self.rollupLiabilityFactor);
        }
        if (self.rollupLiabilityThreshold) {
            dictionaryRepresentation[@"rollupLiabilityThreshold"] = [self.rollupLiabilityThreshold stringValue];
        }
    }
    return dictionaryRepresentation;
}

#pragma mark - BNGDictionaryRepresentation

+ (NSString *)stringFromRollupModel:(BNGRollupModel)rollupModel
{
    NSString *model = @"UNKNOWN";
    switch (rollupModel) {
        case BNGRollupModelStake: {
            model = @"STAKE";
        } break;
        case BNGRollupModelManagedLiability: {
            model = @"MANAGED_LIABILITY";
        } break;
        case BNGRollupModelNone: {
            model = @"NONE";
        } break;
        case BNGRollupModelPayout: {
            model = @"PAYOUT";
        } break;
        default:
            break;
    }
    return model;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ BNGExBestOffersOverrides [bestPricesDepth: %ld] [rollupModel: %@] [rollupLimit: %ld] [rollupLiabilityThreshold: %@] [rollupLiabilityFactor: %ld]",
            [super description],
            (long)self.bestPricesDepth,
            [BNGExBestOffersOverrides stringFromRollupModel:self.rollupLimit],
            (long)self.rollupLimit,
            self.rollupLiabilityThreshold,
            (long)self.rollupLiabilityFactor];
}

@end
