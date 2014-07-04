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

#import "BNGMarketCatalogueDescription.h"

@implementation BNGMarketCatalogueDescription

#pragma mark Transformers

+ (BNGMarketBettingType)marketBettingTypeFromString:(NSString *)bettingType
{
    BNGMarketBettingType type = BNGMarketBettingTypeUnknown;
    NSString *uppercaseBettingType = [bettingType uppercaseString];
    if ([uppercaseBettingType isEqualToString:@"ODDS"]) {
        type = BNGMarketBettingTypeOdds;
    } else if ([uppercaseBettingType isEqualToString:@"LINE"]) {
        type = BNGMarketBettingTypeLine;
    } else if ([uppercaseBettingType isEqualToString:@"RANGE"]) {
        type = BNGMarketBettingTypeRange;
    } else if ([uppercaseBettingType isEqualToString:@"ASIAN_HANDICAP_DOUBLE_LINE"]) {
        type = BNGMarketBettingTypeAsianHandicapDoubleLine;
    } else if ([uppercaseBettingType isEqualToString:@"ASIAN_HANDICAP_SINGLE_LINE"]) {
        type = BNGMarketBettingTypeAsianHandicapSingleLine;
    } else if ([uppercaseBettingType isEqualToString:@"FIXED_ODDS"]) {
        type = BNGMarketBettingTypeFixedOdds;
    } 
    return type;
}

+ (NSString *)stringFromMarketBettingType:(BNGMarketBettingType)bettingType
{
    NSString *type = @"UNKNOWN";
    switch (bettingType) {
        case BNGMarketBettingTypeOdds: {
            type = @"ODDS";
        } break;
        case BNGMarketBettingTypeLine: {
            type = @"LINE";
        } break;
        case BNGMarketBettingTypeRange: {
            type = @"RANGE";
        } break;
        case BNGMarketBettingTypeAsianHandicapDoubleLine: {
            type = @"ASIAN_HANDICAP_DOUBLE_LINE";
        } break;
        case BNGMarketBettingTypeAsianHandicapSingleLine: {
            type = @"ASIAN_HANDICAP_SINGLE_LINE";
        } break;
        case BNGMarketBettingTypeFixedOdds: {
            type = @"FIXED_ODDS";
        } break;
        default:
            break;
    }
    return type;
}

+ (BNGMarketType)marketTypeFromString:(NSString *)marketType
{
    BNGMarketType type = BNGMarketTypeUnknown;
    NSString *uppercaseMarketType = [marketType uppercaseString];
    static NSDictionary *marketMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marketMap = @{
                      @"MATCH_ODDS": @(BNGMarketTypeMatchOdds),
                      @"BOTH_TEAMS_TO_SCORE": @(BNGMarketTypeBothTeamsToScore),
                      @"CLEAN_SHEET": @(BNGMarketTypeCleanSheet),
                      @"CORNER_MATCH_BET": @(BNGMarketTypeCornerMatchBet),
                      @"CORNER_ODDS": @(BNGMarketTypeCornerOdds),
                      @"CORRECT_SCORE": @(BNGMarketTypeCorrectScore),
                      @"CORRECT_SCORE2": @(BNGMarketTypeCorrectScore2),
                      @"DRAW_NO_BET": @(BNGMarketTypeDrawNoBet),
                      @"ET": @(BNGMarketTypeET),
                      @"FIRST_CORNER": @(BNGMarketTypeFirstCorner),
                      @"FIRST_GOAL_ODDS": @(BNGMarketTypeFirstGoalOdds),
                      @"FIRST_GOAL_SCORER": @(BNGMarketTypeFirstGoalScorer),
                      @"FIRST_HALF_GOALS": @(BNGMarketTypeFirstHalfGoals),
                      @"HALF_TIME": @(BNGMarketTypeHalfTime),
                      @"HALF_TIME_FULL_TIME": @(BNGMarketTypeHalfTimeFullTime),
                      @"HALF_TIME_SCORE": @(BNGMarketTypeHalfTimeScore),
                      @"HALF_WITH_MOST_GOALS": @(BNGMarketTypeHalfWithMostGoals),
                      @"HAT_TRICK_SCORED": @(BNGMarketTypeHatTrickScored),
                      @"MONEYLINE": @(BNGMarketTypeMoneyline),
                      @"NEXT_GOAL": @(BNGMarketTypeNextGoal),
                      @"ODD_OR_EVEN": @(BNGMarketTypeOddOrEven),
                      @"OVER_UNDER_05": @(BNGMarketTypeOverUnder5),
                      @"OVER_UNDER_15": @(BNGMarketTypeOverUnder15),
                      @"OVER_UNDER_25": @(BNGMarketTypeOverUnder25),
                      @"OVER_UNDER_35": @(BNGMarketTypeOverUnder35),
                      @"OVER_UNDER_45": @(BNGMarketTypeOverUnder45),
                      @"OVER_UNDER_55": @(BNGMarketTypeOverUnder55),
                      @"OVER_UNDER_65": @(BNGMarketTypeOverUnder65),
                      @"OVER_UNDER_75": @(BNGMarketTypeOverUnder75),
                      @"OVER_UNDER_85": @(BNGMarketTypeOverUnder85),
                      @"OVER_UNDER": @(BNGMarketTypeOverUnder),
                      @"PENALTY_TAKEN": @(BNGMarketTypePenaltyTaken),
                      @"SCORE_CAST": @(BNGMarketTypeScoreCast),
                      @"SENDING_OFF": @(BNGMarketTypeSendingOff),
                      @"SHOWN_A_CARD": @(BNGMarketTypeShownACard),
                      @"TEAM_TOTAL_GOALS": @(BNGMarketTypeTeamTotalGoals),
                      @"TO_SCORE_BOTH_HALVES": @(BNGMarketTypeToScoreBothHalves),
                      @"TO_SCORE": @(BNGMarketTypeToScore),
                      @"TO_QUALIFY": @(BNGMarketTypeToQualify),
                      @"TOTAL_CORNERS": @(BNGMarketTypeTotalCorners),
                      @"TOTAL_GOALS": @(BNGMarketTypeTotalGoals),
                      @"TOTAL_GOALS_INDEX": @(BNGMarketTypeTotalGoalsIndex),
                      @"TOURNAMENT_WINNER": @(BNGMarketTypeTournamentWinner),
                      @"WIN_BOTH_HALVES": @(BNGMarketTypeWinBothHalves),
                      @"WIN_FROM_BEHIND": @(BNGMarketTypeWinFromBehind),
                      @"WIN_TO_NIL": @(BNGMarketTypeWinToNil),
                      @"WIN_HALF": @(BNGMarketTypeWinHalf),
                      @"WINNER": @(BNGMarketTypeWinner),
                      @"UNDIFFERENTIATED": @(BNGMarketTypeUndifferentiated),
                      };
    });
    
    if (marketMap[uppercaseMarketType]) {
        type = [marketMap[uppercaseMarketType] integerValue];
    }
   
    return type;
}

+ (NSString *)stringFromMarketType:(BNGMarketType)marketType
{
    NSString *marketTypeString = @"UNKNOWN";
    switch (marketType) {
        case BNGMarketTypeMatchOdds: {
            marketTypeString = @"MATCH_ODDS";
        } break;
        case BNGMarketTypeAsianHandicap: {
            marketTypeString = @"ASIAN_HANDICAP";
        } break;
        case BNGMarketTypeBookingOdds: {
            marketTypeString = @"BOOKING_ODDS";
        } break;
        case BNGMarketTypeBothTeamsToScore: {
            marketTypeString = @"BOTH_TEAMS_TO_SCORE";
        } break;
        case BNGMarketTypeCleanSheet: {
            marketTypeString = @"CLEAN_SHEET";
        } break;
        case BNGMarketTypeCornerMatchBet: {
            marketTypeString = @"CORNER_MATCH_BET";
        } break;
        case BNGMarketTypeCornerOdds: {
            marketTypeString = @"CORNER_ODDS";
        } break;
        case BNGMarketTypeCorrectScore: {
            marketTypeString = @"CORRECT_SCORE";
        } break;
        case BNGMarketTypeCorrectScore2: {
            marketTypeString = @"CORRECT_SCORE_2";
        } break;
        case BNGMarketTypeDrawNoBet: {
            marketTypeString = @"DRAW_NO_BET";
        } break;
        case BNGMarketTypeET: {
            marketTypeString = @"ET";
        } break;
        case BNGMarketTypeFirstCorner: {
            marketTypeString = @"FIRST_CORNER";
        } break;
        case BNGMarketTypeFirstGoalOdds: {
            marketTypeString = @"FIRST_GOAL_ODDS";
        } break;
        case BNGMarketTypeFirstGoalScorer: {
            marketTypeString = @"FIRST_GOAL_SCORER";
        } break;
        case BNGMarketTypeFirstHalfGoals: {
            marketTypeString = @"FIRST_HALF_GOALS";
        } break;
        case BNGMarketTypeHalfTime: {
            marketTypeString = @"HALF_TIME";
        } break;
        case BNGMarketTypeHalfTimeFullTime: {
            marketTypeString = @"HALF_TIME_FULL_TIME";
        } break;
        case BNGMarketTypeHalfTimeScore: {
            marketTypeString = @"HALF_TIME_SCORE";
        } break;
        case BNGMarketTypeHalfWithMostGoals: {
            marketTypeString = @"HALF_WITH_MOST_GOALS";
        } break;
        case BNGMarketTypeHatTrickScored: {
            marketTypeString = @"HAT_TRICK_SCORED";
        } break;
        case BNGMarketTypeMoneyline: {
            marketTypeString = @"MONEYLINE";
        } break;
        case BNGMarketTypeNextGoal: {
            marketTypeString = @"NEXT_GOAL";
        } break;
        case BNGMarketTypeOddOrEven: {
            marketTypeString = @"ODD_OR_EVEN";
        } break;
        case BNGMarketTypeOverUnder5: {
            marketTypeString = @"OVER_UNDER_05";
        } break;
        case BNGMarketTypeOverUnder15: {
            marketTypeString = @"OVER_UNDER_15";
        } break;
        case BNGMarketTypeOverUnder25: {
            marketTypeString = @"OVER_UNDER_25";
        } break;
        case BNGMarketTypeOverUnder35: {
            marketTypeString = @"OVER_UNDER_35";
        } break;
        case BNGMarketTypeOverUnder45: {
            marketTypeString = @"OVER_UNDER_45";
        } break;
        case BNGMarketTypeOverUnder55: {
            marketTypeString = @"OVER_UNDER_55";
        } break;
        case BNGMarketTypeOverUnder65: {
            marketTypeString = @"OVER_UNDER_65";
        } break;
        case BNGMarketTypeOverUnder75: {
            marketTypeString = @"OVER_UNDER_75";
        } break;
        case BNGMarketTypeOverUnder85: {
            marketTypeString = @"OVER_UNDER_85";
        } break;
        case BNGMarketTypeOverUnder: {
            marketTypeString = @"OVER_UNDER";
        } break;
        case BNGMarketTypePenaltyTaken: {
            marketTypeString = @"PENALTY_TAKEN";
        } break;
        case BNGMarketTypeScoreCast: {
            marketTypeString = @"SCORE_CAST";
        } break;
        case BNGMarketTypeSendingOff: {
            marketTypeString = @"SENDING_OFF";
        } break;
        case BNGMarketTypeShownACard: {
            marketTypeString = @"SHOWN_A_CARD";
        } break;
        case BNGMarketTypeTeamTotalGoals: {
            marketTypeString = @"TEAM_TOTAL_GOALS";
        } break;
        case BNGMarketTypeToScoreBothHalves: {
            marketTypeString = @"TO_SCORE_BOTH_HALVES";
        } break;
        case BNGMarketTypeToScore: {
            marketTypeString = @"TO_SCORE";
        } break;
        case BNGMarketTypeToQualify: {
            marketTypeString = @"TO_QUALIFY";
        } break;
        case BNGMarketTypeTotalCorners: {
            marketTypeString = @"TOTAL_CORNERS";
        } break;
        case BNGMarketTypeTotalGoals: {
            marketTypeString = @"TOTAL_GOALS";
        } break;
        case BNGMarketTypeTotalGoalsIndex: {
            marketTypeString = @"TOTAL_GOALS_INDEX";
        } break;
        case BNGMarketTypeTournamentWinner: {
            marketTypeString = @"TOURNAMENT_WINNER";
        } break;
        case BNGMarketTypeWinBothHalves: {
            marketTypeString = @"WIN_BOTH_HALVES";
        } break;
        case BNGMarketTypeWinFromBehind: {
            marketTypeString = @"WIN_FROM_BEHIND";
        } break;
        case BNGMarketTypeWinToNil: {
            marketTypeString = @"WIN_TO_NIL";
        } break;
        case BNGMarketTypeWinHalf: {
            marketTypeString = @"WIN_HALF";
        } break;
        case BNGMarketTypeWinner: {
            marketTypeString = @"WINNER";
        } break;
        case BNGMarketTypeUndifferentiated: {
            marketTypeString = @"UNDIFFERENTIATED";
        } break;
        default:
            break;
    }
    return marketTypeString;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"BNGMarketCatalogueDescription[bettingType, bspMarket, clarifications, discountAllowed, marketBaseRate, marketTime, marketType, persistenceEnabled, regulator, settleTime, suspendTime, turnInPlayEnabled, wallet]: %@ %d %@ %d %ld %@ %@ %d %@ %@ %@ %d %@", [BNGMarketCatalogueDescription stringFromMarketBettingType:self.bettingType], self.bspMarket, self.clarifications, self.discountAllowed, (long)self.marketBaseRate, self.marketTime, [BNGMarketCatalogueDescription stringFromMarketType:self.marketType], self.persistenceEnabled, self.regulator, self.settleTime, self.suspendTime, self.turnInPlayEnabled, self.wallet];
}

@end
