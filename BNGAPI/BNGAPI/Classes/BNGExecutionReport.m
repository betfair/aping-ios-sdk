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

#import "BNGExecutionReport.h"

@implementation BNGExecutionReport

#pragma mark Transformers

+ (BNGExecutionReportStatus)executionReportStatusFromString:(NSString *)reportStatus
{
    BNGExecutionReportStatus status = BNGExecutionReportStatusUnknown;
    NSString *reportStatusUppercase = [reportStatus uppercaseString];
    if ([reportStatusUppercase isEqualToString:@"SUCCESS"]) {
        status = BNGExecutionReportStatusSuccess;
    } else if ([reportStatusUppercase isEqualToString:@"FAILURE"]) {
        status = BNGExecutionReportStatusFailure;
    } else if ([reportStatusUppercase isEqualToString:@"PROCESSED_WITH_ERRORS"]) {
        status = BNGExecutionReportStatusProcessedWithErrors;
    } else if ([reportStatusUppercase isEqualToString:@"TIMEOUT"]) {
        status = BNGExecutionReportStatusTimeout;
    }
    return status;
}

+ (NSString *)stringFromBNGExecutionReportStatus:(BNGExecutionReportStatus)status
{
    NSString *reportStatus = @"UNKNOWN";
    switch (status) {
        case BNGExecutionReportStatusSuccess: {
            reportStatus = @"SUCCESS";
        } break;
        case BNGExecutionReportStatusFailure: {
            reportStatus = @"FAILURE";
        } break;
        case BNGExecutionReportStatusProcessedWithErrors: {
            reportStatus = @"PROCESSED_WITH_ERRORS";
        } break;
        case BNGExecutionReportStatusTimeout: {
            reportStatus = @"TIMEOUT";
        } break;
        default:
            break;
    }
    return reportStatus;
}

+ (BNGExecutionReportErrorCode)executionReportErrorCodeFromString:(NSString *)errorString
{
    BNGExecutionReportErrorCode errorCode = BNGExecutionReportErrorCodeUnknown;
    static NSDictionary *errorMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        errorMap = @{
                     @"ERROR_IN_MATCHER": @(BNGExecutionReportErrorCodeErrorInMatcher),
                     @"PROCESSED_WITH_ERRORS": @(BNGExecutionReportErrorCodeProcessedWithErrors),
                     @"BET_ACTION_ERROR": @(BNGExecutionReportErrorCodeBetActionError),
                     @"INVALID_ACCOUNT_STATE": @(BNGExecutionReportErrorCodeInvalidAccountState),
                     @"INVALID_WALLET_STATUS": @(BNGExecutionReportErrorCodeInvalidWalletStatus),
                     @"INSUFFICIENT_FUNDS": @(BNGExecutionReportErrorCodeInsufficientFunds),
                     @"LOSS_LIMIT_EXCEEDED": @(BNGExecutionReportErrorCodeLossLimitExceeded),
                     @"MARKET_SUSPENDED": @(BNGExecutionReportErrorCodeMarketSuspended),
                     @"MARKET_NOT_OPEN_FOR_BETTING": @(BNGExecutionReportErrorCodeMarketNotOpenForBetting),
                     @"DUPLICATE_TRANSACTION": @(BNGExecutionReportErrorCodeDuplicateTransaction),
                     @"INVALID_ORDER": @(BNGExecutionReportErrorCodeInvalidOrder),
                     @"INVALID_MARKET_ID": @(BNGExecutionReportErrorCodeInvalidMarketId),
                     @"PERMISSION_DENIED": @(BNGExecutionReportErrorCodePermissionDenied),
                     @"DUPLICATE_BETIDS": @(BNGExecutionReportErrorCodeDuplicateBetIds),
                     @"NO_ACTION_REQUIRED": @(BNGExecutionReportErrorCodeNoActionRequired),
                     @"SERVICE_UNAVAILABLE": @(BNGExecutionReportErrorCodeServiceUnavailable),
                     @"REJECTED_BY_REGULATOR": @(BNGExecutionReportErrorCodeRejectedByRegulartor),
                     };
    });

    if (errorMap[errorString]) {
        errorCode = [errorMap[errorString] integerValue];
    }
    
    return errorCode;
}

+ (NSString *)stringFromBNGExecutionReportErrorCode:(BNGExecutionReportErrorCode)errorCode
{
    NSString *error = @"UNKNOWN";
    switch (errorCode) {
        case BNGExecutionReportErrorCodeBetActionError: {
            error = @"BET_ACTION_ERROR";
        } break;
        case BNGExecutionReportErrorCodeDuplicateBetIds: {
            error = @"DUPLICATE_BET_IDS";
        } break;
        case BNGExecutionReportErrorCodeDuplicateTransaction: {
            error = @"DUPLICATE_TRANSACTION";
        } break;
        case BNGExecutionReportErrorCodeErrorInMatcher: {
            error = @"ERROR_IN_MATCHER";
        } break;
        case BNGExecutionReportErrorCodeInsufficientFunds: {
            error = @"INSUFFICIENT_FUNDS";
        } break;
        case BNGExecutionReportErrorCodeInvalidAccountState: {
            error = @"INVALID_ACCOUNT_STATE";
        } break;
        case BNGExecutionReportErrorCodeInvalidMarketId: {
            error = @"INVALID_MARKET_ID";
        } break;
        case BNGExecutionReportErrorCodeInvalidOrder: {
            error = @"INVALID_ORDER";
        } break;
        case BNGExecutionReportErrorCodeInvalidWalletStatus: {
            error = @"INVALID_WALLET_STATUS";
        } break;
        case BNGExecutionReportErrorCodeLossLimitExceeded: {
            error = @"LOSS_LIMIT_EXCEEDED";
        } break;
        case BNGExecutionReportErrorCodeMarketNotOpenForBetting: {
            error = @"MARKET_NOT_OPEN_FOR_BETTING";
        } break;
        case BNGExecutionReportErrorCodeMarketSuspended: {
            error = @"MARKET_SUSPENDED";
        } break;
        case BNGExecutionReportErrorCodeNoActionRequired: {
            error = @"NO_ACTION_REQUIRED";
        } break;
        case BNGExecutionReportErrorCodePermissionDenied: {
            error = @"PERMISSION_DENIED";
        } break;
        case BNGExecutionReportErrorCodeProcessedWithErrors: {
            error = @"PROCESSED_WITH_ERRORS";
        } break;
        case BNGExecutionReportErrorCodeRejectedByRegulartor: {
            error = @"REJECTED_BY_REGULATOR";
        } break;
        case BNGExecutionReportErrorCodeServiceUnavailable: {
            error = @"SERVICE_UNAVAILABLE";
        } break;
        default:
            break;
    }
    return error;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ BNGExecutionReport [customerRef: %@] [status: %@] [errorCode: %@] [marketId: %@] [instructionReports: %@]",
            [super description],
            self.customerRef,
            [BNGExecutionReport stringFromBNGExecutionReportStatus:self.status],
            [BNGExecutionReport stringFromBNGExecutionReportErrorCode:self.errorCode],
            self.marketId,
            self.instructionReports];
}

@end
