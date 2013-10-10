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

#import <CommonCrypto/CommonCryptor.h>

#import "BNGAccount.h"
#import "NSURLRequest+HTTPBody.h"
#import "BNGLoginURLProtocol.h"
#import "NSString+URLEncoding.h"

@implementation BNGAccount

#pragma mark API Call

+ (BNGMutableURLRequest *)loginWithUserName:(NSString *)username
                                   password:(NSString *)password
                                    product:(NSString *)product
                                redirectUrl:(NSString *)redirectUrl
                            completionBlock:(BNGLoginCompletionBlock)completionBlock
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(product);
    NSParameterAssert(redirectUrl);
    NSParameterAssert(completionBlock);
    
    if (!username) return nil;
    if (!password) return nil;
    if (!product) return nil;
    if (!redirectUrl) return nil;
    if (!completionBlock) return nil;
    
    NSURL *url = [NSURL betfairNGLoginURLForOperation:BNGLoginOperation.login];
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:url];
    // need to remove the BNGHTTPHeaderContentType HTTP header or else the redirect does not fire :(
    [request setValue:nil forHTTPHeaderField:BNGHTTPHeaderContentType];

    [request setHTTPMethod:@"POST"];
    
    [request addBodyKey:@"username" value:username];
    [request addBodyKey:@"password" value:password];
    [request addBodyKey:@"applicationId" value:product];
    [request addBodyKey:@"url" value:redirectUrl];
    [request addBodyKey:@"product" value:product];
    [request addBodyKey:@"redirectMethod" value:@"POST"];
    
    __block id notification = [[NSNotificationCenter defaultCenter] addObserverForName:BNGLoginURLProtocolDidLoginNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        if (!note.userInfo[BNGLoginURLProtocolErrorKey]) {
            
            NSString *productToken = note.userInfo[BNGLoginURLProtocolHTTPBodyKey][@"productToken"];
            NSString *ssoKey = [productToken urlDecodedString];
            
            completionBlock(ssoKey, nil, nil);
            
        } else {
            completionBlock(nil, note.userInfo[BNGLoginURLProtocolErrorKey], nil);
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:notification];
    }];

    return request;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ [accountFunds: %@] [accountDetails: %@]",
            [super description],
            self.accountFunds,
            self.accountDetails];
}

@end
