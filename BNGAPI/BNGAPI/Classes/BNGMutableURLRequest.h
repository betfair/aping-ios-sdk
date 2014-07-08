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

/**
 * Constant header definition for the 'X-Application' HTTP header.
 */
extern NSString * const BNGHTTPHeaderXApplication;

/**
 * Constant header definition for the 'X-Authentication' HTTP header.
 */
extern NSString * const BNGHTTPHeaderXAuthentication;

/**
 * Constant header definition for the 'Content-Type' HTTP header.
 */
extern NSString * const BNGHTTPHeaderContentType;

/**
 * Constant header value for the 'Content-Type' HTTP header.
 */
extern NSString * const BNGHTTPHeaderValueContentTypeDefault;

/**
 * Constant header definition for the 'Accept' HTTP header.
 */
extern NSString * const BNGHTTPHeaderAccept;

/**
 * Constant header definition for the 'Accept-Charset' HTTP header.
 */
extern NSString * const BNGHTTPHeaderAcceptCharset;

/**
 * Constant header value for the 'Accept-Charset' HTTP header.
 */
extern NSString * const BNGHTTPHeaderValueAcceptCharsetDefault;

#pragma mark Enums

/**
 * Used for generic error codes returned from the API server.
 */
typedef NS_ENUM(NSInteger, BNGErrorCode) {
    BNGErrorCodeNoData = 500,
};

@class BNGMarketFilter;

/**
 * Extension on `NSMutableURLRequest` which adds default APING specific headers to
 * every API request. Also used for setting post parameters in the request body.
 */
@interface BNGMutableURLRequest : NSMutableURLRequest

/**
 * Sets the parameters parameter as the body of the POST request.
 * @param parameters key/value pairs which should be sent as part of the POST request.
 */
- (void)setPostParameters:(NSDictionary *)parameters;

/**
 * Sets the parameters parameter as the body of the POST request.
 * @param parameters key/value pairs which should be sent as part of the POST request.
 * @param error JSON Encoding error if any.
 * @return success
 */
- (BOOL)setPostParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error;

/**
 * Sets the parameters parameter as the body of the POST request.
 * @param parameters key/value pairs which should be sent as part of the POST request.
 * @param error JSON Encoding error if any.
 * @param addDefaultParameters dictates whether or not the default parameters (locale/currencyCode) are added to the request.
 * @return success
 */
- (BOOL)setPostParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error addDefaultParameters:(BOOL)addDefaultParameters;

@end
