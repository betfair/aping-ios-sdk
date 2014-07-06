//
//  BNGVenueTest.m
//  BNGAPI
//
//  Created by Sean O' Shea on 7/6/14.
//  Copyright (c) 2014 Betfair. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "APING.h"
#import "BNGVenue.h"
#import "BNGMarketFilter.h"
#import "BNGURLProtocolResourceLoader.h"
#import "BNGTestUtilities.h"

@interface BNGVenueTest : XCTestCase

@end

@implementation BNGVenueTest

- (void)testEventApiCall {
    
    [NSURLProtocol registerClass:[BNGURLProtocolResourceLoader class]];
    
    [[APING sharedInstance] registerApplicationKey:BNGTestUtilitiesApplicationKey ssoKey:BNGTestUtilitiesSSOKey];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    BNGMarketFilter *marketFilter = [[BNGMarketFilter alloc] init];
    marketFilter.eventTypeIds = @[@(1)];
    
    [BNGVenue venuesWithFilter:marketFilter completionBlock:^(NSArray *results, NSError *connectionError, BNGAPIError *apiError) {
       
        // TODO: asserts
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
