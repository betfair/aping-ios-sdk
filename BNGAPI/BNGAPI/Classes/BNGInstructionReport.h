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

#pragma mark Enums

typedef NS_ENUM(NSInteger, BNGInstructionReportStatus) {
    BNGInstructionReportStatusUnknown,
    BNGInstructionReportStatusSuccess,
    BNGInstructionReportStatusFailure,
    BNGInstructionReportStatusTimeout,
};

typedef NS_ENUM(NSInteger, BNGInstructionReportErrorCode) {
    BNGInstructionReportErrorCodeUnknown,
    BNGInstructionReportErrorCodeInvalidBetSize,
    BNGInstructionReportErrorCodeInvalidRunner,
    BNGInstructionReportErrorCodeBetTakenOrLapsed,
    BNGInstructionReportErrorCodeBetInProgress,
    BNGInstructionReportErrorCodeRunnerRemoved,
    BNGInstructionReportErrorCodeMarketNotOpenForBetting,
    BNGInstructionReportErrorCodeLossLimitExceeded,
    BNGInstructionReportErrorCodeMarketNotOpenForBSPBetting,
    BNGInstructionReportErrorCodeInvalidPriceEdit,
    BNGInstructionReportErrorCodeInvalidOdds,
    BNGInstructionReportErrorCodeInsufficientFunds,
    BNGInstructionReportErrorCodeInvalidPersistenceType,
    BNGInstructionReportErrorCodeErrorInMatcher,
    BNGInstructionReportErrorCodeInvalidBackLayCombination,
    BNGInstructionReportErrorCodeErrorInOrder,
    BNGInstructionReportErrorCodeInvalidBidType,
    BNGInstructionReportErrorCodeInvalidBetId,
    BNGInstructionReportErrorCodeCancelledNotPlaced,
    BNGInstructionReportErrorCodeRelatedActionFailed,
    BNGInstructionReportErrorCodeNoActionRequired,
};

@interface BNGInstructionReport : NSObject

/**
 * Gives an overall status for the `BNGInstructionReport`. Client code should inspect this status to see whether the API call succeeded or not.
 */
@property (nonatomic) BNGInstructionReportStatus status;

/**
 * If there are any errors with the API call, this `errorCode` property will be populated to give client code an understanding of what went wrong (if anything)
 */
@property (nonatomic) BNGInstructionReportErrorCode errorCode;

/**
 * Given an reportStatus NSString, this method returns the corresponding `BNGInstructionReportStatus`
 * @param reportStatus NSString representation of a `BNGInstructionReportStatus`
 * @return a `BNGInstructionReportStatus` which corresponds to the reportStatus parameter.
 */
+ (BNGInstructionReportStatus)instructionReportStatusFromString:(NSString *)reportStatus;

/**
 * Given an `BNGInstructionReportStatus` status, this method returns the corresponding NSString
 * @param status a 'BNGInstructionReportStatus'
 * @return a NSString which corresponds to the status parameter.
 */
+ (NSString *)stringFromBNGInstructionReportStatus:(BNGInstructionReportStatus)status;

/**
 * Given an errorCode NSString, this method returns the corresponding `BNGInstructionReportErrorCode`
 * @param errorCode NSString representation of a `BNGInstructionReportErrorCode`
 * @return a `BNGInstructionReportErrorCode` which corresponds to the errorCode parameter.
 */
+ (BNGInstructionReportErrorCode)instructionReportErrorCodeFromString:(NSString *)errorCode;

/**
 * Given an `BNGInstructionReportErrorCode` code, this method returns the corresponding NSString
 * @param code a 'BNGInstructionReportErrorCode'
 * @return a NSString which corresponds to the code parameter.
 */
+ (NSString *)stringFromBNGInstructionReportErrorCode:(BNGInstructionReportErrorCode)code;

@end
