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

struct APINGSupportedLocales {
    __unsafe_unretained NSString *en;
    __unsafe_unretained NSString *da;
    __unsafe_unretained NSString *sv;
    __unsafe_unretained NSString *de;
    __unsafe_unretained NSString *it;
    __unsafe_unretained NSString *el;
    __unsafe_unretained NSString *es;
    __unsafe_unretained NSString *tr;
    __unsafe_unretained NSString *ko;
    __unsafe_unretained NSString *cz;
    __unsafe_unretained NSString *bg;
    __unsafe_unretained NSString *ru;
    __unsafe_unretained NSString *fr;
    __unsafe_unretained NSString *pt;
    __unsafe_unretained NSString *th;
};

struct APINGSupportedCurrencyCodes {
    __unsafe_unretained NSString *gbp;
    __unsafe_unretained NSString *eur;
    __unsafe_unretained NSString *aud;
    __unsafe_unretained NSString *cad;
    __unsafe_unretained NSString *sek;
    __unsafe_unretained NSString *nok;
    __unsafe_unretained NSString *dkk;
    __unsafe_unretained NSString *sgd;
    __unsafe_unretained NSString *hkd;
};

@interface APING : NSObject

/**
 * This is the application key the developer should request from https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG
 */
@property (nonatomic, copy) NSString *applicationKey;

/**
 * This is the SSO token the developer receives after the user authentictes with Betfair.
 */
@property (nonatomic, copy) NSString *ssoKey;

/**
 * A locale parameter is sent with each API call.
 */
@property (nonatomic, copy) NSString *locale;

/**
 * A currencyCode parameter is sent with each API call.
 */
@property (nonatomic, copy) NSString *currencyCode;

/**
 * Singleton accessor for `APING`
 */
+ (APING *)sharedInstance;

/**
 * Used to register an application key with the API client. This application key is sent to Betfair's API servers with every
 * request which is used to identify the client.
 * See https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG
 * for details on requesting an application key.
 * @param applicationKey the application key to send with each API request.
 */
- (void)registerApplicationKey:(NSString*)applicationKey;

/**
 * This method (or registerApplicationKey:applicationKey) <b>MUST</b> be invoked before accessing any of the API-NG services.
 * @param applicationKey the application key to send with each API request.
 * @param ssoKey a ssoKey is like a session token in that it allows Betfair's API servers uniquely identify a particular user.
 * @see `loginWithUserName` in `BNGAccount` for details on how to authenticate with Betfair's API servers.
 */
- (void)registerApplicationKey:(NSString *)applicationKey ssoKey:(NSString *)ssoKey;

@end