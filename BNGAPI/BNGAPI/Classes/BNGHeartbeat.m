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

#import "BNGHeartbeat.h"

#import "NSURL+BNG.h"
#import "APING.h"
#import "BNGAPIError_Private.h"
#import "BNGMutableURLRequest.h"
#import "NSURLConnection+BNGJSON.h"
#import "BNGAPIResponseParser.h"
#import "NSDictionary+BNGError.h"
#import "NSString+RandomCustomerReferenceId.h"

struct BNGHeartbeatRequestField {
    __unsafe_unretained NSString *jsonrpc;
    __unsafe_unretained NSString *method;
    __unsafe_unretained NSString *params;
    __unsafe_unretained NSString *preferredTimeoutSeconds;
    __unsafe_unretained NSString *identifier;
};

static const struct BNGHeartbeatRequestField BNGHeartbeatRequestField = {
    .jsonrpc = @"jsonrpc",
    .method = @"method",
    .params = @"params",
    .preferredTimeoutSeconds = @"preferredTimeoutSeconds",
    .identifier = @"id",
};

@implementation BNGHeartbeat

+ (void)heartbeatForPreferredTimeSeconds:(NSUInteger)preferredTimeoutSeconds
                         completionBlock:(BNGHeartbeatCompletionBlock)completionBlock {
    
    NSParameterAssert(preferredTimeoutSeconds <= 300);
    
    if (preferredTimeoutSeconds > 300) {
        return;
    }
    
    BNGMutableURLRequest *request = [BNGMutableURLRequest requestWithURL:[NSURL betfairNGHeartbeatURL]];
    [request setPostParameters:[BNGHeartbeat parametersForPreferredTimeoutSeconds:preferredTimeoutSeconds] error:nil addDefaultParameters:NO];
    
    [NSURLConnection sendAsynchronousJSONRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, id JSONData, NSError *connectionError) {
                                   
                                   if (connectionError) {
                                       completionBlock(nil, connectionError, nil);
                                   } else if ([JSONData isKindOfClass:[NSDictionary class]]) {
                                       NSDictionary *data = JSONData;
                                       if (!data.isBNGError) {
                                           completionBlock([BNGAPIResponseParser parseBNGHeartbeatReportFromResponse:JSONData], nil, nil);
                                       } else {
                                           completionBlock(nil, [[BNGAPIError alloc] initWithAPINGErrorResponseDictionary:JSONData], nil);
                                       }
                                   } else {
                                       completionBlock(nil, connectionError, [NSError errorWithDomain:BNGErrorDomain
                                                                                       code:BNGErrorCodeNoData
                                                                                   userInfo:nil]);
                                   }
                               }];
}

+ (BNGHeartBeatActionPerformed)heartbeatActionPerformedFromString:(NSString *)actionPerformed
{
    BNGHeartBeatActionPerformed performed = BNGHeartBeatActionPerformedUnknown;
    
    static NSDictionary *actionPerformedMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionPerformedMap = @{@"NONE": @(BNGHeartBeatActionPerformedNone),
                               @"CANCELLATION_REQUEST_SUBMITTED": @(BNGHeartBeatActionPerformedCancellationRequestSubmitted),
                               @"ALL_BETS_CANCELLED": @(BNGHeartBeatActionPerformedAllBetsCancelled),
                               @"SOME_BETS_NOT_CANCELLED": @(BNGHeartBeatActionPerformedSomeBetsNotCancelled),
                               @"CANCELLATION_REQUEST_ERROR": @(BNGHeartBeatActionPerformedCancellationRequestError),
                               @"CANCELLATION_STATUS_UNKNOWN": @(BNGHeartBeatActionPerformedCancellationStatusUnknown),
                               };
    });

    if (actionPerformedMap[actionPerformed]) {
        performed = [actionPerformedMap[actionPerformed] integerValue];
    }
    
    return performed;
}

+ (NSDictionary *)parametersForPreferredTimeoutSeconds:(NSUInteger)preferredTimeoutSeconds
{
    return @{BNGHeartbeatRequestField.jsonrpc: @"2.0", BNGHeartbeatRequestField.method: @"HeartbeatAPING/v1.0/heartbeat", BNGHeartbeatRequestField.params: @{BNGHeartbeatRequestField.preferredTimeoutSeconds: @(preferredTimeoutSeconds)}, BNGHeartbeatRequestField.identifier: [NSString randomCustomerReferenceId]};
}

@end
