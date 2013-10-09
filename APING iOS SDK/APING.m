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
// This product includes software developed by the <organization>.
// 4. Neither the name of the <organization> nor the
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

#import "APING.h"

static const struct APINGSupportedLocales APINGSupportedLocales = {
    .en = @"en",
    .da = @"da",
    .sv = @"sv",
    .de = @"de",
    .it = @"it",
    .el = @"el",
    .es = @"es",
    .tr = @"tr",
    .ko = @"ko",
    .cz = @"cz",
    .bg = @"bg",
    .ru = @"ru",
    .fr = @"fr",
    .pt = @"pt",
    .th = @"th",
};

static const struct APINGSupportedCurrencyCodes APINGSupportedCurrencyCodes = {
    .gbp = @"GBP",
    .eur = @"EUR",
    .aud = @"AUD",
    .cad = @"CAD",
    .sek = @"SEK",
    .nok = @"NOK",
    .dkk = @"DKK",
    .sgd = @"SGD",
    .hkd = @"HKD",
};

@interface APING ()

@property (nonatomic, readonly) NSSet *supportedLocales;
@property (nonatomic, readonly) NSSet *supportedCurrencyCodes;

@end

@implementation APING

@synthesize locale = _locale;
@synthesize currencyCode = _currencyCode;

+ (APING *)sharedInstance
{
    static APING *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APING alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _supportedLocales       = [NSSet setWithArray:@[APINGSupportedLocales.en, APINGSupportedLocales.da, APINGSupportedLocales.sv, APINGSupportedLocales.de, APINGSupportedLocales.it, APINGSupportedLocales.el, APINGSupportedLocales.es, APINGSupportedLocales.tr, APINGSupportedLocales.ko, APINGSupportedLocales.cz, APINGSupportedLocales.bg, APINGSupportedLocales.ru, APINGSupportedLocales.fr, APINGSupportedLocales.pt, APINGSupportedLocales.th]];
        _supportedCurrencyCodes = [NSSet setWithArray:@[APINGSupportedCurrencyCodes.gbp, APINGSupportedCurrencyCodes.eur, APINGSupportedCurrencyCodes.aud, APINGSupportedCurrencyCodes.cad, APINGSupportedCurrencyCodes.sek, APINGSupportedCurrencyCodes.nok, APINGSupportedCurrencyCodes.dkk, APINGSupportedCurrencyCodes.sgd, APINGSupportedCurrencyCodes.hkd]];
    }
    
    return self;
}

- (void)registerApplicationKey:(NSString *)applicationKey
{
    NSParameterAssert(applicationKey.length);

    self.applicationKey = applicationKey;
}

- (void)registerApplicationKey:(NSString *)applicationKey ssoKey:(NSString *)ssoKey
{
    NSParameterAssert(applicationKey.length);
    NSParameterAssert(!ssoKey || ssoKey.length);
    
    self.applicationKey = applicationKey;
    self.ssoKey = ssoKey;
}

- (NSString *)applicationKey
{
    if (!_applicationKey) {
        [NSException raise:@"APING registerApplicationKey:ssoKey must be invoked before trying to access the applicationKey property"
                    format:@"Expected a valid applicationKey key, but received %@", _applicationKey];
    }
    return _applicationKey;
}

- (NSString *)defaultCurrencyCode
{
    return APINGSupportedCurrencyCodes.gbp;
}

- (void)setLocale:(NSString *)locale
{
    if (![self.supportedLocales containsObject:locale]) {
        [NSException raise:@"locale parameter must be a supported locale."
                    format:@"Expected a valid locale identifier (see APINGSupportedLocales), but received %@", locale];
    }
    
    _locale = [locale copy];
}

- (NSString *)locale
{
    return _locale ?: APINGSupportedLocales.en; // always have a default ready
}

- (void)setCurrencyCode:(NSString *)currencyCode
{
    if (![self.supportedCurrencyCodes containsObject:currencyCode]) {
        [NSException raise:@"currencyCode parameter must be a supported currency code."
                    format:@"Expected a valid currency code (see APINGSupportedCurrencyCodes), but received %@", currencyCode];
    }
    _currencyCode = [currencyCode copy];
}

- (NSString *)currencyCode
{
    return _currencyCode ?: APINGSupportedCurrencyCodes.gbp; // always have a default ready
}

@end