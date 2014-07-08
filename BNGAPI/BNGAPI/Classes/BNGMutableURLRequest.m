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

#import "BNGMutableURLRequest.h"

#import "BNGMarketFilter.h"
#import "APING.h"

NSString * const BNGHTTPHeaderXApplication              = @"X-Application";
NSString * const BNGHTTPHeaderXAuthentication           = @"X-Authentication";
NSString * const BNGHTTPHeaderContentType               = @"Content-Type";
NSString * const BNGHTTPHeaderValueContentTypeDefault   = @"application/json";
NSString * const BNGHTTPHeaderAccept                    = @"Accept";
NSString * const BNGHTTPHeaderAcceptCharset             = @"Accept-Charset";
NSString * const BNGHTTPHeaderValueAcceptCharsetDefault = @"UTF-8";

static NSString * const BNGMutableURLRequestDefaultEncoding = @"UTF-8";

struct BNGDefaultParameterField {
    __unsafe_unretained NSString *locale;
    __unsafe_unretained NSString *currencyCode;
};

static const struct BNGDefaultParameterField BNGDefaultParameterField = {
    .locale = @"locale",
    .currencyCode = @"currencyCode",
};

@implementation BNGMutableURLRequest

#pragma mark Initialisation

- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    
    self = [super initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    
    if (self) {
        
        // Ensure All BNG required headers are set.
        [self addDefaultHeadersToRequest];
    }
    
    return self;
}

- (void)addDefaultHeadersToRequest
{
    if ([APING sharedInstance].ssoKey.length) {
        [self addValue:[APING sharedInstance].ssoKey forHTTPHeaderField:BNGHTTPHeaderXAuthentication];
    }

    [self addValue:[APING sharedInstance].applicationKey  forHTTPHeaderField:BNGHTTPHeaderXApplication];
    [self addValue:BNGHTTPHeaderValueContentTypeDefault   forHTTPHeaderField:BNGHTTPHeaderContentType];
    [self addValue:BNGHTTPHeaderValueContentTypeDefault   forHTTPHeaderField:BNGHTTPHeaderAccept];
    [self addValue:BNGHTTPHeaderValueAcceptCharsetDefault forHTTPHeaderField:BNGHTTPHeaderAcceptCharset];
}

- (void)setPostParameters:(NSDictionary *)parameters
{
    [self setPostParameters:parameters error:nil addDefaultParameters:YES];
}

- (BOOL)setPostParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
    return [self setPostParameters:parameters error:error addDefaultParameters:YES];
}

- (BOOL)setPostParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error addDefaultParameters:(BOOL)addDefaultParameters
{
    NSMutableDictionary *allParameters = [parameters mutableCopy];
    if (addDefaultParameters) {
        // make sure to always add the two parameters which should be included in each and every request
        [allParameters addEntriesFromDictionary:@{
                                                  BNGDefaultParameterField.locale: [APING sharedInstance].locale,
                                                  BNGDefaultParameterField.currencyCode: [APING sharedInstance].currencyCode,
                                                  }];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:allParameters
                                                   options:kNilOptions
                                                     error:error];
    
    if (data) {
        [self setHTTPMethod:@"POST"];
        [self setHTTPBody:data];
        return YES;
    } else {
        return NO;
    }
}

@end
