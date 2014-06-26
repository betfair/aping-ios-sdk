//
//  BNGExBestOffersOverridesTest.m
//  BNGAPI
//
//  Created by Sean O' Shea on 6/26/14.
//  Copyright (c) 2014 Betfair. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Foundation/Foundation.h>

#import "BNGExBestOffersOverrides.h"

@interface BNGExBestOffersOverridesTest : XCTestCase

@end

@implementation BNGExBestOffersOverridesTest

- (void)testStringFromRollupModel
{
    XCTAssert([[BNGExBestOffersOverrides stringFromRollupModel:BNGRollupModelManagedLiability] isEqualToString:@"MANAGED_LIABILITY"], @"");
    XCTAssert([[BNGExBestOffersOverrides stringFromRollupModel:BNGRollupModelNone] isEqualToString:@"NONE"], @"");
    XCTAssert([[BNGExBestOffersOverrides stringFromRollupModel:BNGRollupModelPayout] isEqualToString:@"PAYOUT"], @"");
    XCTAssert([[BNGExBestOffersOverrides stringFromRollupModel:BNGRollupModelStake] isEqualToString:@"STAKE"], @"");
    XCTAssert([[BNGExBestOffersOverrides stringFromRollupModel:BNGRollupModelUnknown] isEqualToString:@"UNKNOWN"], @"");
}

- (void)testDictionaryRepresentation
{
    BNGExBestOffersOverrides *exBestOffersOverrides = [[BNGExBestOffersOverrides alloc] init];
    exBestOffersOverrides.rollupModel = BNGRollupModelManagedLiability;
    exBestOffersOverrides.rollupLimit = 1;
    exBestOffersOverrides.bestPricesDepth = 3;
    exBestOffersOverrides.rollupLiabilityFactor = 1;
    exBestOffersOverrides.rollupLiabilityThreshold = [NSDecimalNumber decimalNumberWithString:@"2"];
    
    NSDictionary *dictionary = exBestOffersOverrides.dictionaryRepresentation;
    XCTAssert([dictionary[@"rollupModel"] isEqualToString:@"MANAGED_LIABILITY"], @"");
    XCTAssert([dictionary[@"rollupLimit"] isEqualToNumber:@(1)], @"");
    XCTAssert([dictionary[@"bestPricesDepth"] isEqualToNumber:@(3)], @"");
    XCTAssert([dictionary[@"rollupLiabilityFactor"] isEqualToNumber:@(1)], @"");
    XCTAssert([dictionary[@"rollupLiabilityThreshold"] isEqualToString:@"2"], @"");
}

@end
