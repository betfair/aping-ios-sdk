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

typedef NS_ENUM(NSInteger, BNGExecutionReportStatus) {
    BNGExecutionReportStatusUnknown,
    BNGExecutionReportStatusSuccess,
    BNGExecutionReportStatusFailure,
    BNGExecutionReportStatusProcessedWithErrors,
    BNGExecutionReportStatusTimeout,
};

typedef NS_ENUM(NSInteger, BNGExecutionReportErrorCode) {
    BNGExecutionReportErrorCodeUnknown,
    BNGExecutionReportErrorCodeErrorInMatcher,
    BNGExecutionReportErrorCodeProcessedWithErrors,
    BNGExecutionReportErrorCodeBetActionError,
    BNGExecutionReportErrorCodeInvalidAccountState,
    BNGExecutionReportErrorCodeInvalidWalletStatus,
    BNGExecutionReportErrorCodeInsufficientFunds,
    BNGExecutionReportErrorCodeLossLimitExceeded,
    BNGExecutionReportErrorCodeMarketSuspended,
    BNGExecutionReportErrorCodeMarketNotOpenForBetting,
    BNGExecutionReportErrorCodeDuplicateTransaction,
    BNGExecutionReportErrorCodeInvalidOrder,
    BNGExecutionReportErrorCodeInvalidMarketId,
    BNGExecutionReportErrorCodePermissionDenied,
    BNGExecutionReportErrorCodeDuplicateBetIds,
    BNGExecutionReportErrorCodeNoActionRequired,
    BNGExecutionReportErrorCodeServiceUnavailable,
    BNGExecutionReportErrorCodeRejectedByRegulartor,
};

@interface BNGExecutionReport : NSObject

/**
 * CustomerRefs are echo'ed back to client code only if they are provided
 * as a parameter to the place, update or replace order API calls.
 */
@property (nonatomic, copy) NSString *customerRef;

/**
 * Gives an overall status for the `BNGExecutionReport`. It's up to the client
 * code to first check this status code and then inspect each of the status
 * codes in the `instructionReports` collection to get an understanding of
 * whether the API call failed, succeeded fully or partially succeeded.
 */
@property (nonatomic) BNGExecutionReportStatus status;
@property (nonatomic) BNGExecutionReportErrorCode errorCode;

/**
 * Unique identifier for the market on which this order was placed.
 */
@property (nonatomic, copy) NSString *marketId;

/**
 * Collection of reports which allows the client code understand whether
 * each order placed on the market was successfully executed or not.
 */
@property (nonatomic, copy) NSArray *instructionReports;

#pragma mark Transformers

/**
 * Given an reportStatus NSString, this method returns the corresponding `BNGExecutionReportStatus`
 * @param reportStatus NSString representation of a `BNGExecutionReportStatus`
 * @return a `BNGExecutionReportStatus` which corresponds to the reportStatus parameter.
 */
+ (BNGExecutionReportStatus)executionReportStatusFromString:(NSString *)reportStatus;

/**
 * Given an `BNGExecutionReportStatus` projection, this method returns the corresponding NSString
 * @param status a 'BNGExecutionReportStatus'
 * @return a NSString which corresponds to the status parameter.
 */
+ (NSString *)stringFromBNGExecutionReportStatus:(BNGExecutionReportStatus)status;

/**
 * Given an errorString NSString, this method returns the corresponding `BNGExecutionReportErrorCode`
 * @param errorString NSString representation of a `BNGExecutionReportErrorCode`
 * @return a `BNGExecutionReportErrorCode` which corresponds to the reportStatus parameter.
 */
+ (BNGExecutionReportErrorCode)executionReportErrorCodeFromString:(NSString *)errorString;

/**
 * Given an `BNGExecutionReportErrorCode` projection, this method returns the corresponding NSString
 * @param errorCode a 'BNGExecutionReportErrorCode'
 * @return a NSString which corresponds to the errorCode parameter.
 */
+ (NSString *)stringFromBNGExecutionReportErrorCode:(BNGExecutionReportErrorCode)errorCode;

@end
