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

extern NSString * const BNGHTTPHeaderXApplication;
extern NSString * const BNGHTTPHeaderXAuthentication;
extern NSString * const BNGHTTPHeaderContentType;
extern NSString * const BNGHTTPHeaderValueContentTypeDefault;
extern NSString * const BNGHTTPHeaderAccept;
extern NSString * const BNGHTTPHeaderAcceptCharset;
extern NSString * const BNGHTTPHeaderValueAcceptCharsetDefault;

#pragma mark Enums

typedef NS_ENUM(NSInteger, APINGErrorCode) {
    APINGErrorCodeNoData = 500,
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
 */
- (void)setPostParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error;

@end
