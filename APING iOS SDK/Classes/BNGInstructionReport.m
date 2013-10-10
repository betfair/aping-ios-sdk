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

#import "BNGInstructionReport.h"

@implementation BNGInstructionReport

#pragma mark Transformers

+ (BNGInstructionReportStatus)instructionReportStatusFromString:(NSString *)reportStatus
{
    BNGInstructionReportStatus status = BNGInstructionReportStatusUnknown;
    NSString *reportStatusUppercase = [reportStatus uppercaseString];
    if ([reportStatusUppercase isEqualToString:@"SUCCESS"]) {
        status = BNGInstructionReportStatusSuccess;
    } else if ([reportStatusUppercase isEqualToString:@"FAILURE"]) {
        status = BNGInstructionReportStatusFailure;
    } else if ([reportStatusUppercase isEqualToString:@"TIMEOUT"]) {
        status = BNGInstructionReportStatusTimeout;
    }
    return status;
}

+ (NSString *)stringFromBNGInstructionReportStatus:(BNGInstructionReportStatus)status
{
    NSString *reportStatus = @"UNKNOWN";
    switch (status) {
        case BNGInstructionReportStatusSuccess:
            reportStatus = @"SUCCESS";
            break;
        case BNGInstructionReportStatusFailure:
            reportStatus = @"FAILURE";
            break;
        case BNGInstructionReportStatusTimeout:
            reportStatus = @"TIMEOUT";
            break;
        default:
            break;
    }
    return reportStatus;
}

+ (BNGInstructionReportErrorCode)instructionReportErrorCodeFromString:(NSString *)errorCode
{
    BNGInstructionReportErrorCode code = BNGInstructionReportErrorCodeUnknown;
    NSString *errorCodeUppercase = [errorCode uppercaseString];
    if ([errorCodeUppercase isEqualToString:@"INVALID_BET_SIZE"]) {
        code = BNGInstructionReportErrorCodeInvalidBetSize;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_RUNNER"]) {
        code = BNGInstructionReportErrorCodeInvalidRunner;
    } else if ([errorCodeUppercase isEqualToString:@"BET_TAKEN_OR_LAPSED"]) {
        code = BNGInstructionReportErrorCodeBetTakenOrLapsed;
    } else if ([errorCodeUppercase isEqualToString:@"BET_IN_PROGRESS"]) {
        code = BNGInstructionReportErrorCodeBetInProgress;
    } else if ([errorCodeUppercase isEqualToString:@"RUNNER_REMOVED"]) {
        code = BNGInstructionReportErrorCodeRunnerRemoved;
    } else if ([errorCodeUppercase isEqualToString:@"MARKET_NOT_OPEN_FOR_BETTING"]) {
        code = BNGInstructionReportErrorCodeMarketNotOpenForBetting;
    } else if ([errorCodeUppercase isEqualToString:@"LOSS_LIMIT_EXCEEDED"]) {
        code = BNGInstructionReportErrorCodeLossLimitExceeded;
    } else if ([errorCodeUppercase isEqualToString:@"MARKET_NOT_OPEN_FOR_BSP_BETTING"]) {
        code = BNGInstructionReportErrorCodeMarketNotOpenForBSPBetting;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_PRICE_EDIT"]) {
        code = BNGInstructionReportErrorCodeInvalidPriceEdit;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_ODDS"]) {
        code = BNGInstructionReportErrorCodeInvalidOdds;
    } else if ([errorCodeUppercase isEqualToString:@"INSUFFICIENT_FUNDS"]) {
        code = BNGInstructionReportErrorCodeInsufficientFunds;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_PERSISTENCE_TYPE"]) {
        code = BNGInstructionReportErrorCodeInvalidPersistenceType;
    } else if ([errorCodeUppercase isEqualToString:@"ERROR_IN_MATCHER"]) {
        code = BNGInstructionReportErrorCodeErrorInMatcher;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_BACK_LAY_COMBINATION"]) {
        code = BNGInstructionReportErrorCodeInvalidBackLayCombination;
    } else if ([errorCodeUppercase isEqualToString:@"ERROR_IN_ORDER"]) {
        code = BNGInstructionReportErrorCodeErrorInOrder;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_BID_TYPE"]) {
        code = BNGInstructionReportErrorCodeInvalidBidType;
    } else if ([errorCodeUppercase isEqualToString:@"INVALID_BET_ID"]) {
        code = BNGInstructionReportErrorCodeInvalidBetId;
    } else if ([errorCodeUppercase isEqualToString:@"CANCELLED_NOT_PLACED"]) {
        code = BNGInstructionReportErrorCodeCancelledNotPlaced;
    } else if ([errorCodeUppercase isEqualToString:@"RELATED_ACTION_FAILED"]) {
        code = BNGInstructionReportErrorCodeRelatedActionFailed;
    } else if ([errorCodeUppercase isEqualToString:@"NO_ACTION_REQUIRED"]) {
        code = BNGInstructionReportErrorCodeNoActionRequired;
    }
    return code;
}

+ (NSString *)stringFromBNGInstructionReportErrorCode:(BNGInstructionReportErrorCode)code
{
    NSString *errorCode = @"UNKNOWN";
    switch (code) {
        case BNGInstructionReportErrorCodeBetInProgress:
            errorCode = @"BET_IN_PROGRESS";
            break;
        case BNGInstructionReportErrorCodeBetTakenOrLapsed:
            errorCode = @"BET_TAKEN_OR_LAPSED";
            break;
        case BNGInstructionReportErrorCodeCancelledNotPlaced:
            errorCode = @"CANCELLED_NOT_PLACED";
            break;
        case BNGInstructionReportErrorCodeErrorInMatcher:
            errorCode = @"ERROR_IN_MATCHER";
            break;
        case BNGInstructionReportErrorCodeErrorInOrder:
            errorCode = @"ERROR_IN_ORDER";
            break;
        case BNGInstructionReportErrorCodeInsufficientFunds:
            errorCode = @"INSUFFICIENT_FUNDS";
            break;
        case BNGInstructionReportErrorCodeInvalidBackLayCombination:
            errorCode = @"INVALID_BACK_LAY_COMBINATION";
            break;
        case BNGInstructionReportErrorCodeInvalidBetId:
            errorCode = @"INVALID_BET_ID";
            break;
        case BNGInstructionReportErrorCodeInvalidBetSize:
            errorCode = @"INVALID_BET_SIZE";
            break;
        case BNGInstructionReportErrorCodeInvalidBidType:
            errorCode = @"INVALID_BID_TYPE";
            break;
        case BNGInstructionReportErrorCodeInvalidOdds:
            errorCode = @"INVALID_ODDS";
            break;
        case BNGInstructionReportErrorCodeInvalidPersistenceType:
            errorCode = @"INVALID_PERSISTENCE_TYPE";
            break;
        case BNGInstructionReportErrorCodeInvalidPriceEdit:
            errorCode = @"INVALID_PRICE_EDIT";
            break;
        case BNGInstructionReportErrorCodeInvalidRunner:
            errorCode = @"INVALID_RUNNER";
            break;
        case BNGInstructionReportErrorCodeLossLimitExceeded:
            errorCode = @"LOSS_LIMIT_EXCEEDED";
            break;
        case BNGInstructionReportErrorCodeMarketNotOpenForBetting:
            errorCode = @"MARKET_NOT_OPEN_FOR_BETTING";
            break;
        case BNGInstructionReportErrorCodeMarketNotOpenForBSPBetting:
            errorCode = @"MARKET_NOT_OPEN_FOR_BSP_BETTING";
            break;
        case BNGInstructionReportErrorCodeNoActionRequired:
            errorCode = @"NO_ACTION_REQUIRED";
            break;
        case BNGInstructionReportErrorCodeRelatedActionFailed:
            errorCode = @"CODE_RELATED_ACTION_FAILED";
            break;
        case BNGInstructionReportErrorCodeRunnerRemoved:
            errorCode = @"RUNNER_REMOVED";
            break;
        default:
            break;
    }
    return errorCode;
}

@end
