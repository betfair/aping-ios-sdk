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

#import "BNGAPIError.h"
#import "BNGAPIError_Private.h"

NSString * const BNGErrorDomain = @"BNGErrorDomain";
NSString * const BNGErrorFaultCodeIdentifier = @"faultcode";
NSString * const BNGErrorFaultStringIdentifier = @"faultstring";
NSString * const BNGErrorErrorStringIdentifier = @"error";

NSString * const BNGErrorCougarCodeIdentifier = @"DSC";

static NSString *BNGSplashedAPIIdentifier = @"splash/unplanned";

@implementation BNGAPIError

#pragma mark Initialisation

- (instancetype)initWithAPINGErrorResponseDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDomain:BNGErrorDomain
                            code:[dictionary[@"error"][@"code"] integerValue]
                        userInfo:dictionary];
    
    if (self) {

    }
    
    return self;
}

- (instancetype)initWithURLResponse:(NSURLResponse *)response
{
    NSInteger code = BNGAPIErrorCodeUnexpectedError;
    if ([response.URL.absoluteString rangeOfString:BNGSplashedAPIIdentifier].location != NSNotFound) {
        code = BNGAPIErrorCodeServiceBusy;
    }
    
    self = [super initWithDomain:BNGErrorDomain code:code userInfo:nil];
    
    if (self) {
        
        
    }
    
    return self;
}

- (BNGAPICougarErrorCode)cougarErrorCode {
    
    BNGAPICougarErrorCode errorCode = BNGAPICougarErrorCodeUnknown;
    
    if (self.userInfo && self.userInfo[@"error"]) {
        NSString *errorMessage = self.userInfo[@"error"][@"message"];
        if (errorMessage) {
            static NSDictionary *errorCodesMap;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                errorCodesMap = @{@"DSC-0001" : @(BNGAPICougarErrorCodeStartupError),
                                  @"DSC-0002" : @(BNGAPICougarErrorCodeFrameworkError),
                                  @"DSC-0003" : @(BNGAPICougarErrorCodeInvocationResultIncorrect),
                                  @"DSC-0005" : @(BNGAPICougarErrorCodeServiceRuntimeException),
                                  @"DSC-0006" : @(BNGAPICougarErrorCodeSOAPDeserialisationFailure),
                                  @"DSC-0007" : @(BNGAPICougarErrorCodeXMLDeserialisationFailure),
                                  @"DSC-0008" : @(BNGAPICougarErrorCodeJSONDeserialisationParseFailure),
                                  @"DSC-0009" : @(BNGAPICougarErrorCodeClassConversionFailure),
                                  @"DSC-0010" : @(BNGAPICougarErrorCodeInvalidInputMediaType),
                                  @"DSC-0011" : @(BNGAPICougarErrorCodeContentTypeNotValid),
                                  @"DSC-0012" : @(BNGAPICougarErrorCodeMediaTypeParseFailure),
                                  @"DSC-0013" : @(BNGAPICougarErrorCodeAcceptTypeNotValid),
                                  @"DSC-0014" : @(BNGAPICougarErrorCodeResponseContentTypeNotValid),
                                  @"DSC-0015" : @(BNGAPICougarErrorCodeSecurityException),
                                  @"DSC-0016" : @(BNGAPICougarErrorCodeServiceDisabled),
                                  @"DSC-0017" : @(BNGAPICougarErrorCodeOperationDisabled),
                                  @"DSC-0018" : @(BNGAPICougarErrorCodeMandatoryNotDefined),
                                  @"DSC-0019" : @(BNGAPICougarErrorCodeTimeout),
                                  @"DSC-0020" : @(BNGAPICougarErrorCodeBinDeserialisationParseFailure),
                                  @"DSC-0021" : @(BNGAPICougarErrorCodeNoSuchOperation),
                                  @"DSC-0022" : @(BNGAPICougarErrorCodeSubscriptionAlreadyActiveForEvent),
                                  @"DSC-0023" : @(BNGAPICougarErrorCodeNoSuchService),
                                  @"DSC-0024" : @(BNGAPICougarErrorCodeRescriptDeserialisationFailure),
                                  @"DSC-0025" : @(BNGAPICougarErrorCodeJMSTransportCommunicationFailure),
                                  @"DSC-0026" : @(BNGAPICougarErrorCodeRemoteCougarCommunicationFailure),
                                  @"DSC-0027" : @(BNGAPICougarErrorCodeOutputChannelClosedCantWrite),
                                  @"DSC-0028" : @(BNGAPICougarErrorCodeXMLSerialisationFailure),
                                  @"DSC-0029" : @(BNGAPICougarErrorCodeJSONSerialisationFailure),
                                  @"DSC-0030" : @(BNGAPICougarErrorCodeSOAPSerialisationFailure),
                                  @"DSC-0031" : @(BNGAPICougarErrorCodeNoRequestsFound),
                                  @"DSC-0032" : @(BNGAPICougarErrorCodeEPNSerialisationFailure),
                                  @"DSC-0033" : @(BNGAPICougarErrorCodeUnidentifiedCaller),
                                  @"DSC-0034" : @(BNGAPICougarErrorCodeUnknownCaller),
                                  @"DSC-0035" : @(BNGAPICougarErrorCodeUnrecognisedCredentials),
                                  @"DSC-0036" : @(BNGAPICougarErrorCodeInvalidCredentials),
                                  @"DSC-0037" : @(BNGAPICougarErrorCodeSubscriptionRequired),
                                  @"DSC-0038" : @(BNGAPICougarErrorCodeOperationForbidden),
                                  @"DSC-0039" : @(BNGAPICougarErrorCodeNoLocationSupplied),
                                  @"DSC-0040" : @(BNGAPICougarErrorCodeBannedLocation),
                                  };
            });
            if (errorCodesMap[errorMessage]) {
                errorCode = [errorCodesMap[errorMessage] intValue];
            }
        }
    }
    
    return errorCode;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ BNGAPIError [code: %ld] [userInfo: %@] [domain: %@]",
            [super description],
            self.code,
            self.userInfo,
            self.domain];
}
            
@end
