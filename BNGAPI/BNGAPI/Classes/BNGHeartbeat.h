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

#import "BNGHeartbeatReport.h"

@class BNGAPIError;

typedef void(^BNGReplaceOrdersCompletionBlock)(BNGHeartbeatReport *report, NSError *connectionError, BNGAPIError *apiError);

/**
 * Domain object for a heartbeat operation on APING. Allows client code to execute a heartbeat API call and specify
 */
@interface BNGHeartbeat : NSObject

#pragma mark API Calls

/**
 * This heartbeat operation is provided to help customers have their positions managed automatically in the event of their API clients losing connectivity with the Betfair API. If a heartbeat request is not received within a prescribed time period, then Betfair will attempt to cancel all 'LIMIT' type bets for the given customer on the given exchange. There is no guarantee that this service will result in all bets being cancelled as there are a number of circumstances where bets are unable to be cancelled. Manual intervention is strongly advised in the event of a loss of connectivity to ensure that positions are correctly managed. If this service becomes unavailable for any reason, then your heartbeat will be unregistered automatically to avoid bets being inadvertently cancelled upon resumption of service. you should manage your position manually until the service is resumed. Heartbeat data may also be lost in the unlikely event of nodes failing within the cluster, which may result in your position not being managed until a subsequent heartbeat request is received.
 * @param preferredTimeoutSeconds Maximum period in seconds that may elapse (without a subsequent heartbeat request), before a cancellation request is automatically submitted on your behalf. The minimum value is 10, the maximum value permitted is 300. Passing 0 will result in your heartbeat being unregistered (or ignored if you have no current heartbeat registered). You will still get an actionPerformed value returned when passing 0, so this may be used to determine if any action was performed since your last heartbeat, without actually registering a new heartbeat. Passing a negative value will result in an error being returned, INVALID_INPUT_DATA. Any errors while registering your heartbeat will result in a error being returned, UNEXPECTED_ERROR.
 */
+ (void)heartbeatForPreferredTimeSeconds:(NSUInteger)preferredTimeoutSeconds
                completionBlock:(BNGReplaceOrdersCompletionBlock)completionBlock;

#pragma mark Transformers

/**
 * Given an actionPerformed NSString, this method returns the corresponding `BNGHeartBeatActionPerformed`
 * @param actionPerformed NSString representation of a `BNGHeartBeatActionPerformed`
 * @return a `BNGHeartBeatActionPerformed` which corresponds to the actionPerformed parameter.
 */
+ (BNGHeartBeatActionPerformed)heartbeatActionPerformedFromString:(NSString *)actionPerformed;

@end
