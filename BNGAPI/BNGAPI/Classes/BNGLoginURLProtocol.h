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

extern NSString * const BNGLoginURLProtocolDidLoginNotification;
extern NSString * const BNGLoginURLProtocolErrorKey;
extern NSString * const BNGLoginURLProtocolHTTPBodyKey;

// See https://api.developer.betfair.com/services/webapps/docs/plugins/viewsource/viewpagesrc.action?pageId=3834915 for details
struct APINGLoginErrors {
    __unsafe_unretained NSString *ACCOUNT_ALREADY_LOCKED;
    __unsafe_unretained NSString *ACCOUNT_NOW_LOCKED;
    __unsafe_unretained NSString *AGENT_CLIENT_MASTER;
    __unsafe_unretained NSString *AGENT_CLIENT_MASTER_SUSPENDED;
    __unsafe_unretained NSString *BETTING_RESTRICTED_LOCATION;
    __unsafe_unretained NSString *CERT_AUTH_REQUIRED;
    __unsafe_unretained NSString *CHANGE_PASSWORD_REQUIRED;
    __unsafe_unretained NSString *CLOSED;
    __unsafe_unretained NSString *DANISH_AUTHORIZATION_REQUIRED;
    __unsafe_unretained NSString *DENMARK_MIGRATION_REQUIRED;
    __unsafe_unretained NSString *DUPLICATE_CARDS;
    __unsafe_unretained NSString *INVALID_CONNECTIVITY_TO_REGULATOR_DK;
    __unsafe_unretained NSString *INVALID_CONNECTIVITY_TO_REGULATOR_IT;
    __unsafe_unretained NSString *INVALID_USERNAME_OR_PASSWORD;
    __unsafe_unretained NSString *ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED;
    __unsafe_unretained NSString *KYC_SUSPEND;
    __unsafe_unretained NSString *NOT_AUTHORIZED_BY_REGULATOR_DK;
    __unsafe_unretained NSString *NOT_AUTHORIZED_BY_REGULATOR_IT;
    __unsafe_unretained NSString *PENDING_AUTH;
    __unsafe_unretained NSString *PERSONAL_MESSAGE_REQUIRED;
    __unsafe_unretained NSString *SECURITY_QUESTION_WRONG_3X;
    __unsafe_unretained NSString *SECURITY_RESTRICTED_LOCATION;
    __unsafe_unretained NSString *SELF_EXCLUDED;
    __unsafe_unretained NSString *SPAIN_MIGRATION_REQUIRED;
    __unsafe_unretained NSString *SPANISH_TERMS_ACCEPTANCE_REQUIRED;
    __unsafe_unretained NSString *SUSPENDED;
    __unsafe_unretained NSString *TELBET_TERMS_CONDITIONS_NA;
    __unsafe_unretained NSString *TRADING_MASTER;
    __unsafe_unretained NSString *TRADING_MASTER_SUSPENDED;
};

typedef enum BNGLoginErrorCode : NSInteger {
    BNGLoginUnknownErrorCode = NSIntegerMin,
} BNGLoginErrorCode;

@interface BNGLoginURLProtocol : NSURLProtocol

+ (NSString *)registeredScheme;
+ (void)registerWithScheme:(NSString *)scheme;

@end
