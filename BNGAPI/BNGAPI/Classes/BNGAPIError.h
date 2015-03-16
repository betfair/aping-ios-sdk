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

#import <Foundation/Foundation.h>

/**
 * The APINGErrorDomain is used as the domain for BNGAPIError and custom NSErrors returned by BNG.
 * Errors in this domain are in addition to errors returned by underlying frameworks that are passed up.
 * The nature of errors passed through may change in the future.
 */
extern NSString * const BNGErrorDomain;

/**
 * Unique identifier for the fault code reported in APING errors.
 */
extern NSString * const BNGErrorFaultCodeIdentifier;

/**
 * Unique identifier for the fault string reported in APING errors.
 */
extern NSString * const BNGErrorFaultStringIdentifier;

/**
 * Unique identifier for the error string reported in APING errors.
 */
extern NSString * const BNGErrorErrorStringIdentifier;

/**
 * A set of generic error codes which can be returned for the API server for any operation.
 */
typedef NS_ENUM(NSInteger, BNGAPIErrorCode) {
    BNGAPIErrorCodeTooMuchData               =  1,
    BNGAPIErrorCodeInvalidInputData          =  2,
    BNGAPIErrorCodeInvalidSessionInformation =  3,
    BNGAPIErrorCodeNoAppKey                  =  4,
    BNGAPIErrorCodeNoSession                 =  5,
    BNGAPIErrorCodeUnexpectedError           =  6,
    BNGAPIErrorCodeInvalidAppKey             =  7,
    BNGAPIErrorCodeTooManyRequests           =  8,
    BNGAPIErrorCodeServiceBusy               =  9,
    BNGAPIErrorCodeTimeoutError              = 10,
};

/**
 * A set of cougar error codes which can be returned from the API server for any operation. Cougar is the container in which API-NG resides (see https://github.com/betfair/cougar for details). See https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Common+Error+Codes and https://github.com/betfair/cougar-documentation/blob/master/legacy/Cougar_Fault_Reporting.md for some explanations of the error codes.
 */
typedef NS_ENUM(NSInteger, BNGAPICougarErrorCode) {
    BNGAPICougarErrorCodeUnknown                            = 0,
    BNGAPICougarErrorCodeStartupError                       = 1,
    BNGAPICougarErrorCodeFrameworkError                     = 2,
    BNGAPICougarErrorCodeInvocationResultIncorrect          = 3,
    BNGAPICougarErrorCodeServiceRuntimeException            = 4,
    BNGAPICougarErrorCodeSOAPDeserialisationFailure         = 5,
    BNGAPICougarErrorCodeXMLDeserialisationFailure          = 6,
    BNGAPICougarErrorCodeJSONDeserialisationParseFailure    = 7,
    BNGAPICougarErrorCodeClassConversionFailure             = 8,
    BNGAPICougarErrorCodeInvalidInputMediaType              = 9,
    BNGAPICougarErrorCodeContentTypeNotValid                = 10,
    BNGAPICougarErrorCodeMediaTypeParseFailure              = 11,
    BNGAPICougarErrorCodeAcceptTypeNotValid                 = 12,
    BNGAPICougarErrorCodeResponseContentTypeNotValid        = 13,
    BNGAPICougarErrorCodeSecurityException                  = 14,
    BNGAPICougarErrorCodeServiceDisabled                    = 15,
    BNGAPICougarErrorCodeOperationDisabled                  = 16,
    BNGAPICougarErrorCodeMandatoryNotDefined                = 17,
    BNGAPICougarErrorCodeTimeout                            = 18,
    BNGAPICougarErrorCodeBinDeserialisationParseFailure     = 19,
    BNGAPICougarErrorCodeNoSuchOperation                    = 20,
    BNGAPICougarErrorCodeSubscriptionAlreadyActiveForEvent  = 21,
    BNGAPICougarErrorCodeNoSuchService                      = 22,
    BNGAPICougarErrorCodeRescriptDeserialisationFailure     = 23,
    BNGAPICougarErrorCodeJMSTransportCommunicationFailure   = 24,
    BNGAPICougarErrorCodeRemoteCougarCommunicationFailure   = 25,
    BNGAPICougarErrorCodeOutputChannelClosedCantWrite       = 26,
    BNGAPICougarErrorCodeXMLSerialisationFailure            = 27,
    BNGAPICougarErrorCodeJSONSerialisationFailure           = 28,
    BNGAPICougarErrorCodeSOAPSerialisationFailure           = 29,
    BNGAPICougarErrorCodeNoRequestsFound                    = 30,
    BNGAPICougarErrorCodeEPNSerialisationFailure            = 31,
    BNGAPICougarErrorCodeUnidentifiedCaller                 = 32,
    BNGAPICougarErrorCodeUnknownCaller                      = 33,
    BNGAPICougarErrorCodeUnrecognisedCredentials            = 34,
    BNGAPICougarErrorCodeInvalidCredentials                 = 35,
    BNGAPICougarErrorCodeSubscriptionRequired               = 36,
    BNGAPICougarErrorCodeOperationForbidden                 = 37,
    BNGAPICougarErrorCodeNoLocationSupplied                 = 38,
    BNGAPICougarErrorCodeBannedLocation                     = 39
};

/**
 * Simple extension of NSError which includes BNG specific fields which help to
 * uniquely identify and describe the error.
 */
@interface BNGAPIError : NSError

/**
 * Cougar specific identifier for this `BNGAPIError`. Not all `BNGAPIErrors` are directly related to cougar errors, but this property will be set accordingly if the response from the API server indicates an underlying cougar error.
 */
@property (nonatomic, readonly) BNGAPICougarErrorCode cougarErrorCode;

@end
