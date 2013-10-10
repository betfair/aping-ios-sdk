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

#import "BNGPriceProjection.h"

#import "BNGExBestOffersOverrides.h"

@implementation BNGPriceProjection

#pragma mark - BNGDictionaryRepresentation

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
    if (self.priceData) {
        [dictionaryRepresentation setObject:self.priceData forKey:@"priceData"];
    }
    if (self.exBestOffersOverrides) {
        [dictionaryRepresentation setObject:[self.exBestOffersOverrides dictionaryRepresentation] forKey:@"exBestOffersOverrides"];
    }
    if (self.virtualise) {
        [dictionaryRepresentation setObject:@"true" forKey:@"virtualise"];
    }
    if (self.rolloverStakes) {
        [dictionaryRepresentation setObject:@"true" forKey:@"rolloverStakes"];
    }
    return dictionaryRepresentation;
}

#pragma mark - Transformers

+ (NSString *)stringFromPriceData:(BNGPriceData)priceData
{
    NSString *data;
    switch (priceData) {
        case BNGPriceDataSPAvailable:
            data = @"SP_AVAILABLE";
            break;
        case BNGPriceDataSPTraded:
            data = @"SP_TRADED";
            break;
        case BNGPriceDataExBestOffers:
            data = @"EX_BEST_OFFERS";
            break;
        case BNGPriceDataExAllOffers:
            data = @"EX_ALL_OFFERS";
            break;
        case BNGPriceDataExTraded:
            data = @"EX_TRADED";
            break;
        case BNGPriceDataUnknown:
            data = @"UNKNOWN";
            break;
    }
    return data;
}

@end
