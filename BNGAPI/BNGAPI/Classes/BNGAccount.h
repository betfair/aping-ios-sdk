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

#import "BNGAccountFunds.h"
#import "BNGAccountDetails.h"
#import "BNGMutableURLRequest.h"

/**
 * Domain object which holds state on the a user's funds & any additional details
 * associated with the account.
 */
@interface BNGAccount : NSObject

/**
 * Contains details on a user's wallet details.
 */
@property (nonatomic) BNGAccountFunds *accountFunds;

/**
 * Contains user specific information such as firstName, lastName, currencyCode etc.
 */
@property (nonatomic) BNGAccountDetails *accountDetails;

/**
 * Authenticates a user. ALL parameters are required.
 * @param username the username to log in with.
 * @param password the password associated with the username.
 * @param product unique product identifier.
 * @param redirectUrl url to send to the login API call which will be hit once the API call returns.
 * @param completionBlock executed once the API call returns.
 * @return `BNGMutableURLRequest` the request sent to log in.
 */
+ (BNGMutableURLRequest *)loginWithUserName:(NSString *)username
                                   password:(NSString *)password
                                    product:(NSString *)product
                                redirectUrl:(NSString *)redirectUrl
                            completionBlock:(BNGLoginCompletionBlock)completionBlock;

@end
