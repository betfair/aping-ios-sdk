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

#import "BNGRunner.h"

static const struct BNGRunnerMetadata BNGRunnerMetadata = {
    .adjustedRating = @"ADJUSTED_RATING",
    .age = @"AGE",
    .bred = @"BRED",
    .clothNumber = @"CLOTH_NUMBER",
    .coloursDescription = @"COLOURS_DESCRIPTION",
    .coloursFilename = @"COLOURS_FILENAME",
    .colourType = @"COLOUR_TYPE",
    .damsireBred = @"DAMSIRE_BRED",
    .damsireName = @"DAMSIRE_NAME",
    .damsireYearBorn = @"DAMSIRE_YEAR_BORN",
    .damBred = @"DAM_BRED",
    .damName = @"DAM_NAME",
    .damYearBorn = @"DAM_YEAR_BORN",
    .daysSinceLastRun = @"DAYS_SINCE_LAST_RUN",
    .forecasePriceDenominator = @"FORECASTPRICE_DENOMINATOR",
    .forecasePriceNumerator = @"FORECASTPRICE_NUMERATOR",
    .form = @"FORM",
    .jockeyClaim = @"JOCKEY_CLAIM",
    .jockeyName = @"JOCKEY_NAME",
    .officialRating = @"OFFICIAL_RATING",
    .ownerName = @"OWNER_NAME",
    .sexType = @"SEX_TYPE",
    .sireBred = @"SIRE_BRED",
    .sireName = @"SIRE_NAME",
    .sireYearBorn = @"SIRE_YEAR_BORN",
    .stallDraw = @"STALL_DRAW",
    .trainerName = @"TRAINER_NAME",
    .wearing = @"WEARING",
    .weightUnits = @"WEIGHT_UNITS",
    .weightValue = @"WEIGHT_VALUE",
};

static NSString * const SilkBaseUrl = @"http://content-cache.betfair.com/feeds_images/Horses/SilkColours/";

@implementation BNGRunner

#pragma mark Transformers

+ (BNGRunnerStatus)runnerStatusFromString:(NSString *)runnerStatus
{
    BNGRunnerStatus status = BNGRunnerStatusUnknown;
    NSString *runnerStatusUppercase = [runnerStatus uppercaseString];   
    if ([runnerStatusUppercase isEqualToString:@"ACTIVE"]) {
        status = BNGRunnerStatusActive;
    } else if ([runnerStatusUppercase isEqualToString:@"WINNER"]) {
        status = BNGRunnerStatusWinner;
    } else if ([runnerStatusUppercase isEqualToString:@"LOSER"]) {
        status = BNGRunnerStatusLoser;
    } else if ([runnerStatusUppercase isEqualToString:@"REMOVED_VACANT"]) {
        status = BNGRunnerStatusRemovedVacant;
    } else if ([runnerStatusUppercase isEqualToString:@"REMOVED"]) {
        status = BNGRunnerStatusRemoved;
    }
    return status;
}

- (NSURL *)runnerSilkUrl
{
    NSURL *silkUrl;
    NSString *coloursFileName = self.metadata[BNGRunnerMetadata.coloursFilename];
    if (coloursFileName) {
        NSString *fileName = [coloursFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
        silkUrl = fileName ? [NSURL URLWithString:[SilkBaseUrl stringByAppendingString:fileName]] : nil;
    }
    return silkUrl;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [selectionId: %lld] [runnerId: %lld] [status: %ld] [lastPriceTraded: %@] [totalMatched: %@] [orders: %@] [matches: %@] [exchangePrices: %@] [startingPrices: %@]",
            [super description],
            self.selectionId,
            self.runnerId,
            (long)self.status,
            self.lastPriceTraded,
            self.totalMatched,
            self.orders,
            self.matches,
            self.exchangePrices,
            self.startingPrices];
}

@end