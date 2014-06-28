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
    NSString *uppercaseBettingType = [marketType uppercaseString];
    if ([uppercaseBettingType isEqualToString:@"MATCH_ODDS"]) {
        type = BNGMarketTypeMatchOdds;
    } else if ([uppercaseBettingType isEqualToString:@"ASIAN_HANDICAP"]) {
        type = BNGMarketTypeAsianHandicap;
    } else if ([uppercaseBettingType isEqualToString:@"BOOKING_ODDS"]) {
        type = BNGMarketTypeBookingOdds;
    } else if ([uppercaseBettingType isEqualToString:@"BOTH_TEAMS_TO_SCORE"]) {
        type = BNGMarketTypeBothTeamsToScore;
    } else if ([uppercaseBettingType isEqualToString:@"CLEAN_SHEET"]) {
        type = BNGMarketTypeCleanSheet;
    } else if ([uppercaseBettingType isEqualToString:@"CORNER_MATCH_BET"]) {
        type = BNGMarketTypeCornerMatchBet;
    } else if ([uppercaseBettingType isEqualToString:@"CORNER_ODDS"]) {
        type = BNGMarketTypeCornerOdds;
    } else if ([uppercaseBettingType isEqualToString:@"CORRECT_SCORE"]) {
        type = BNGMarketTypeCorrectScore;
    } else if ([uppercaseBettingType isEqualToString:@"CORRECT_SCORE2"]) {
        type = BNGMarketTypeCorrectScore2;
    } else if ([uppercaseBettingType isEqualToString:@"DRAW_NO_BET"]) {
        type = BNGMarketTypeDrawNoBet;
    } else if ([uppercaseBettingType isEqualToString:@"ET"]) {
        type = BNGMarketTypeET;
    } else if ([uppercaseBettingType isEqualToString:@"FIRST_CORNER"]) {
        type = BNGMarketTypeFirstCorner;
    } else if ([uppercaseBettingType isEqualToString:@"FIRST_GOAL_ODDS"]) {
        type = BNGMarketTypeFirstGoalOdds;
    } else if ([uppercaseBettingType isEqualToString:@"FIRST_GOAL_SCORER"]) {
        type = BNGMarketTypeFirstGoalScorer;
    } else if ([uppercaseBettingType isEqualToString:@"FIRST_HALF_GOALS"]) {
        type = BNGMarketTypeFirstHalfGoals;
    } else if ([uppercaseBettingType isEqualToString:@"HALF_TIME"]) {
        type = BNGMarketTypeHalfTime;
    } else if ([uppercaseBettingType isEqualToString:@"HALF_TIME_FULL_TIME"]) {
        type = BNGMarketTypeHalfTimeFullTime;
    } else if ([uppercaseBettingType isEqualToString:@"HALF_TIME_SCORE"]) {
        type = BNGMarketTypeHalfTimeScore;
    } else if ([uppercaseBettingType isEqualToString:@"HALF_WITH_MOST_GOALS"]) {
        type = BNGMarketTypeHalfWithMostGoals;
    } else if ([uppercaseBettingType isEqualToString:@"HAT_TRICK_SCORED"]) {
        type = BNGMarketTypeHatTrickScored;
    } else if ([uppercaseBettingType isEqualToString:@"MONEYLINE"]) {
        type = BNGMarketTypeMoneyline;
    } else if ([uppercaseBettingType isEqualToString:@"NEXT_GOAL"]) {
        type = BNGMarketTypeNextGoal;
    } else if ([uppercaseBettingType isEqualToString:@"ODD_OR_EVEN"]) {
        type = BNGMarketTypeOddOrEven;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_05"]) {
        type = BNGMarketTypeOverUnder5;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_15"]) {
        type = BNGMarketTypeOverUnder15;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_25"]) {
        type = BNGMarketTypeOverUnder25;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_35"]) {
        type = BNGMarketTypeOverUnder35;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_45"]) {
        type = BNGMarketTypeOverUnder45;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_55"]) {
        type = BNGMarketTypeOverUnder55;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_65"]) {
        type = BNGMarketTypeOverUnder65;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_75"]) {
        type = BNGMarketTypeOverUnder75;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER_85"]) {
        type = BNGMarketTypeOverUnder85;
    } else if ([uppercaseBettingType isEqualToString:@"OVER_UNDER"]) {
        type = BNGMarketTypeOverUnder;
    } else if ([uppercaseBettingType isEqualToString:@"PENALTY_TAKEN"]) {
        type = BNGMarketTypePenaltyTaken;
    } else if ([uppercaseBettingType isEqualToString:@"SCORE_CAST"]) {
        type = BNGMarketTypeScoreCast;
    } else if ([uppercaseBettingType isEqualToString:@"SENDING_OFF"]) {
        type = BNGMarketTypeSendingOff;
    } else if ([uppercaseBettingType isEqualToString:@"SHOWN_A_CARD"]) {
        type = BNGMarketTypeShownACard;
    } else if ([uppercaseBettingType isEqualToString:@"TEAM_TOTAL_GOALS"]) {
        type = BNGMarketTypeTeamTotalGoals;
    } else if ([uppercaseBettingType isEqualToString:@"TO_SCORE_BOTH_HALVES"]) {
        type = BNGMarketTypeToScoreBothHalves;
    } else if ([uppercaseBettingType isEqualToString:@"TO_SCORE"]) {
        type = BNGMarketTypeToScore;
    } else if ([uppercaseBettingType isEqualToString:@"TO_QUALIFY"]) {
        type = BNGMarketTypeToQualify;
    } else if ([uppercaseBettingType isEqualToString:@"TOTAL_CORNERS"]) {
        type = BNGMarketTypeTotalCorners;
    } else if ([uppercaseBettingType isEqualToString:@"TOTAL_GOALS"]) {
        type = BNGMarketTypeTotalGoals;
    } else if ([uppercaseBettingType isEqualToString:@"TOTAL_GOALS_INDEX"]) {
        type = BNGMarketTypeTotalGoalsIndex;
    } else if ([uppercaseBettingType isEqualToString:@"TOURNAMENT_WINNER"]) {
        type = BNGMarketTypeTournamentWinner;
    } else if ([uppercaseBettingType isEqualToString:@"WIN_BOTH_HALVES"]) {
        type = BNGMarketTypeWinBothHalves;
    } else if ([uppercaseBettingType isEqualToString:@"WIN_FROM_BEHIND"]) {
        type = BNGMarketTypeWinFromBehind;
    } else if ([uppercaseBettingType isEqualToString:@"WIN_TO_NIL"]) {
        type = BNGMarketTypeWinToNil;
    } else if ([uppercaseBettingType isEqualToString:@"WIN_HALF"]) {
        type = BNGMarketTypeWinHalf;
    } else if ([uppercaseBettingType isEqualToString:@"WINNER"]) {
        type = BNGMarketTypeWinner;
    } else if ([uppercaseBettingType isEqualToString:@"UNDIFFERENTIATED"]) {
        type = BNGMarketTypeUndifferentiated;
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
