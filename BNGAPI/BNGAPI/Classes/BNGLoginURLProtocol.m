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

#import "BNGLoginURLProtocol.h"

#import "NSURLRequest+HTTPBody.h"
#import "NSURL+BNG.h"

NSString * const BNGLoginURLProtocolDidLoginNotification    = @"BNGLoginURLProtocolDidLoginNotification";
NSString * const BNGLoginURLProtocolErrorKey                = @"BNGLoginURLProtocolErrorKey";
NSString * const BNGLoginURLProtocolHTTPBodyKey             = @"BNGLoginURLProtocolHTTPBodyKey";

static const struct APINGLoginErrors APINGLoginErrors = {
    .ACCOUNT_ALREADY_LOCKED = @"ACCOUNT_ALREADY_LOCKED",
    .ACCOUNT_NOW_LOCKED = @"ACCOUNT_NOW_LOCKED",
    .AGENT_CLIENT_MASTER = @"AGENT_CLIENT_MASTER",
    .AGENT_CLIENT_MASTER_SUSPENDED = @"AGENT_CLIENT_MASTER_SUSPENDED",
    .BETTING_RESTRICTED_LOCATION = @"BETTING_RESTRICTED_LOCATION",
    .CERT_AUTH_REQUIRED = @"CERT_AUTH_REQUIRED",
    .CHANGE_PASSWORD_REQUIRED = @"CHANGE_PASSWORD_REQUIRED",
    .CLOSED = @"CLOSED",
    .DANISH_AUTHORIZATION_REQUIRED = @"DANISH_AUTHORIZATION_REQUIRED",
    .DENMARK_MIGRATION_REQUIRED = @"DENMARK_MIGRATION_REQUIRED",
    .DUPLICATE_CARDS = @"DUPLICATE_CARDS",
    .INVALID_CONNECTIVITY_TO_REGULATOR_DK = @"INVALID_CONNECTIVITY_TO_REGULATOR_DK",
    .INVALID_CONNECTIVITY_TO_REGULATOR_IT = @"INVALID_CONNECTIVITY_TO_REGULATOR_IT",
    .INVALID_USERNAME_OR_PASSWORD = @"INVALID_USERNAME_OR_PASSWORD",
    .ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED = @"ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED",
    .KYC_SUSPEND = @"KYC_SUSPEND",
    .NOT_AUTHORIZED_BY_REGULATOR_DK = @"NOT_AUTHORIZED_BY_REGULATOR_DK",
    .NOT_AUTHORIZED_BY_REGULATOR_IT = @"NOT_AUTHORIZED_BY_REGULATOR_IT",
    .PENDING_AUTH = @"PENDING_AUTH",
    .PERSONAL_MESSAGE_REQUIRED = @"PERSONAL_MESSAGE_REQUIRED",
    .SECURITY_QUESTION_WRONG_3X = @"SECURITY_QUESTION_WRONG_3X",
    .SECURITY_RESTRICTED_LOCATION = @"SECURITY_RESTRICTED_LOCATION",
    .SELF_EXCLUDED = @"SELF_EXCLUDED",
    .SPAIN_MIGRATION_REQUIRED = @"SPAIN_MIGRATION_REQUIRED",
    .SPANISH_TERMS_ACCEPTANCE_REQUIRED = @"SPANISH_TERMS_ACCEPTANCE_REQUIRED",
    .SUSPENDED = @"SUSPENDED",
    .TELBET_TERMS_CONDITIONS_NA = @"TELBET_TERMS_CONDITIONS_NA",
    .TRADING_MASTER = @"TRADING_MASTER",
    .TRADING_MASTER_SUSPENDED = @"TRADING_MASTER_SUSPENDED",
};

static NSString *BFLoginURLScheme;

@implementation BNGLoginURLProtocol

+ (NSString *)registeredScheme
{
    return BFLoginURLScheme;
}

+ (void)registerWithScheme:(NSString *)scheme
{
    if (!BFLoginURLScheme) {
        [NSURLProtocol registerClass:self];
    }
    
    BFLoginURLScheme = [scheme copy];
}

+ (void)unregisterClass:(Class)protocolClass
{
    [super unregisterClass:protocolClass];
    BFLoginURLScheme = nil;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([request.URL.scheme isEqualToString:BFLoginURLScheme]) {
        
        return YES;
        
    } else if ([request.URL.absoluteString hasPrefix:[NSString stringWithFormat:@"%@/view/login", BNGBaseLoginString]]) {
        
        static NSDictionary *errorCodes;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{

            errorCodes = @{APINGLoginErrors.ACCOUNT_ALREADY_LOCKED: @YES,
                           APINGLoginErrors.ACCOUNT_NOW_LOCKED: @YES,
                           APINGLoginErrors.AGENT_CLIENT_MASTER: @YES,
                           APINGLoginErrors.AGENT_CLIENT_MASTER_SUSPENDED: @YES,
                           APINGLoginErrors.BETTING_RESTRICTED_LOCATION: @YES,
                           APINGLoginErrors.CERT_AUTH_REQUIRED: @YES,
                           APINGLoginErrors.CHANGE_PASSWORD_REQUIRED: @YES,
                           APINGLoginErrors.CLOSED: @YES,
                           APINGLoginErrors.DANISH_AUTHORIZATION_REQUIRED: @YES,
                           APINGLoginErrors.DENMARK_MIGRATION_REQUIRED: @YES,
                           APINGLoginErrors.DUPLICATE_CARDS: @YES,
                           APINGLoginErrors.INVALID_CONNECTIVITY_TO_REGULATOR_DK: @YES,
                           APINGLoginErrors.INVALID_CONNECTIVITY_TO_REGULATOR_IT: @YES,
                           APINGLoginErrors.INVALID_USERNAME_OR_PASSWORD: @YES,
                           APINGLoginErrors.ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED: @YES,
                           APINGLoginErrors.KYC_SUSPEND: @YES,
                           APINGLoginErrors.NOT_AUTHORIZED_BY_REGULATOR_DK: @YES,
                           APINGLoginErrors.NOT_AUTHORIZED_BY_REGULATOR_IT: @YES,
                           APINGLoginErrors.PENDING_AUTH: @YES,
                           APINGLoginErrors.PERSONAL_MESSAGE_REQUIRED: @YES,
                           APINGLoginErrors.SECURITY_QUESTION_WRONG_3X: @YES,
                           APINGLoginErrors.SECURITY_RESTRICTED_LOCATION: @YES,
                           APINGLoginErrors.SELF_EXCLUDED: @YES,
                           APINGLoginErrors.SPAIN_MIGRATION_REQUIRED: @YES,
                           APINGLoginErrors.SPANISH_TERMS_ACCEPTANCE_REQUIRED: @YES,
                           APINGLoginErrors.SUSPENDED: @YES,
                           APINGLoginErrors.TELBET_TERMS_CONDITIONS_NA: @YES,
                           APINGLoginErrors.TRADING_MASTER: @YES,
                           APINGLoginErrors.TRADING_MASTER_SUSPENDED: @YES,};
        });
        
        NSString *httpBodyParameter = request.httpBodyDictionary[@"errorCode"] ? request.httpBodyDictionary[@"errorCode"] : @"";
        NSString *httpQueryParameter = request.httpQueryParams[@"errorCode"] ? request.httpQueryParams[@"errorCode"] : @"";
        
        return (errorCodes[httpBodyParameter] || errorCodes[httpQueryParameter]);
    } else {
        return NO;
    }
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)aRequest toRequest:(NSURLRequest *)bRequest
{
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                        MIMEType:@"text/plain"
                                           expectedContentLength:0
                                                textEncodingName:@"UTF8"];

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    NSDictionary *bodyDictionary = self.request.httpBodyDictionary;
    userInfo[BNGLoginURLProtocolHTTPBodyKey] = bodyDictionary;
        
    if (bodyDictionary[@"errorCode"]) {
        userInfo[BNGLoginURLProtocolErrorKey] = [NSError errorWithDomain:bodyDictionary[@"errorCode"]
                                                                    code:BNGLoginUnknownErrorCode
                                                                userInfo:nil];
    } else {
        if (self.request.httpQueryParams[@"errorCode"]) {
            userInfo[BNGLoginURLProtocolErrorKey] = [NSError errorWithDomain:self.request.httpQueryParams[@"errorCode"]
                                                                        code:BNGLoginUnknownErrorCode
                                                                    userInfo:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BNGLoginURLProtocolDidLoginNotification
                                                        object:nil
                                                      userInfo:[userInfo copy]];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    [self.client URLProtocolDidFinishLoading:self];
}

@end