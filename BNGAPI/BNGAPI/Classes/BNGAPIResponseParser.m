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

#import "BNGAPIResponseParser.h"

#import "BNGEventResult.h"
#import "BNGEvent.h"
#import "BNGEventTypeResult.h"
#import "BNGEventType.h"
#import "BNGMarketBook.h"
#import "BNGRunner.h"
#import "BNGAccountFunds.h"
#import "BNGAccount.h"
#import "BNGMarketCatalogue.h"
#import "BNGCompetition.h"
#import "BNGMarketCatalogueDescription.h"
#import "BNGOrder.h"
#import "BNGCurrentOrderSummaryReport.h"
#import "BNGPriceSize.h"
#import "BNGPlaceExecutionReport.h"
#import "BNGPlaceInstructionReport.h"
#import "BNGPlaceInstruction.h"
#import "BNGLimitOrder.h"
#import "BNGLimitOnCloseOrder.h"
#import "BNGMarketOnCloseOrder.h"
#import "BNGCancelExecutionReport.h"
#import "BNGCancelInstructionReport.h"
#import "BNGCancelInstruction.h"
#import "BNGExchangePrices.h"
#import "BNGStartingPrices.h"
#import "BNGReplaceExecutionReport.h"
#import "BNGReplaceInstructionReport.h"
#import "BNGUpdateExecutionReport.h"
#import "NSNumber+DecimalConversion.h"
#import "BNGCountryCode.h"
#import "BNGCountryCodeResult.h"
#import "BNGCompetitionResult.h"

struct BNGAccountFundsField {
    __unsafe_unretained NSString *availableToBetBalance;
    __unsafe_unretained NSString *exposure;
    __unsafe_unretained NSString *exposureLimit;
    __unsafe_unretained NSString *retainedCommission;
};

struct BNGAccountDetailsField {
    __unsafe_unretained NSString *currencyCode;
    __unsafe_unretained NSString *firstName;
    __unsafe_unretained NSString *lastName;
    __unsafe_unretained NSString *localeCode;
    __unsafe_unretained NSString *region;
    __unsafe_unretained NSString *timezone;
    __unsafe_unretained NSString *discountRate;
    __unsafe_unretained NSString *pointsBalance;
};

struct BNGEventField {
    __unsafe_unretained NSString *event;
    __unsafe_unretained NSString *marketCount;
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *countryCode;
    __unsafe_unretained NSString *openDate;
    __unsafe_unretained NSString *timezone;
};

struct BNGEventTypeResultField {
    __unsafe_unretained NSString *eventType;
    __unsafe_unretained NSString *marketCount;
};

struct BNGEventTypeField {
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *name;
};

struct BNGMarketBookField {
    __unsafe_unretained NSString *betDelay;
    __unsafe_unretained NSString *bspReconciled;
    __unsafe_unretained NSString *complete;
    __unsafe_unretained NSString *crossMatching;
    __unsafe_unretained NSString *inplay;
    __unsafe_unretained NSString *isMarketDataDelayed;
    __unsafe_unretained NSString *lastMatchTime;
    __unsafe_unretained NSString *marketId;
    __unsafe_unretained NSString *numberOfActiveRunners;
    __unsafe_unretained NSString *numberOfRunners;
    __unsafe_unretained NSString *numberOfWinners;
    __unsafe_unretained NSString *runners;
    __unsafe_unretained NSString *runnersVoidable;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *totalAvailable;
    __unsafe_unretained NSString *totalMatched;
    __unsafe_unretained NSString *version;
};

struct BNGCompetitionField {
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *name;
};

struct BNGRunnerField {
    __unsafe_unretained NSString *handicap;
    __unsafe_unretained NSString *lastPriceTraded;
    __unsafe_unretained NSString *selectionId;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *totalMatched;
    __unsafe_unretained NSString *metadata;
    __unsafe_unretained NSString *runnerId;
    __unsafe_unretained NSString *sortPriority;
    __unsafe_unretained NSString *ex;
    __unsafe_unretained NSString *sp;
    __unsafe_unretained NSString *availableToBack;
    __unsafe_unretained NSString *availableToLay;
    __unsafe_unretained NSString *tradedVolume;
    __unsafe_unretained NSString *backStakeTaken;
    __unsafe_unretained NSString *farPrice;
    __unsafe_unretained NSString *layLiabilityTaken;
    __unsafe_unretained NSString *nearPrice;
};

struct BNGMarketCatalogueField {
    __unsafe_unretained NSString *competition;
    __unsafe_unretained NSString *description;
    __unsafe_unretained NSString *event;
    __unsafe_unretained NSString *eventType;
    __unsafe_unretained NSString *marketId;
    __unsafe_unretained NSString *marketName;
    __unsafe_unretained NSString *marketStartTime;
    __unsafe_unretained NSString *runners;
};

struct BNGMarketCatalogueDescriptionField {
    __unsafe_unretained NSString *bettingType;
    __unsafe_unretained NSString *bspMarket;
    __unsafe_unretained NSString *clarifications;
    __unsafe_unretained NSString *discountAllowed;
    __unsafe_unretained NSString *marketBaseRate;
    __unsafe_unretained NSString *marketTime;
    __unsafe_unretained NSString *marketType;
    __unsafe_unretained NSString *persistenceEnabled;
    __unsafe_unretained NSString *regulator;
    __unsafe_unretained NSString *rules;
    __unsafe_unretained NSString *rulesHasDate;
    __unsafe_unretained NSString *settleTime;
    __unsafe_unretained NSString *suspendTime;
    __unsafe_unretained NSString *turnInPlayEnabled;
    __unsafe_unretained NSString *wallet;
};

struct BNGCurrentOrderSummaryReportField {
    __unsafe_unretained NSString *currentOrders;
    __unsafe_unretained NSString *moreAvailable;
};

struct BNGOrderField {
    __unsafe_unretained NSString *averagePriceMatched;
    __unsafe_unretained NSString *betId;
    __unsafe_unretained NSString *bspLiability;
    __unsafe_unretained NSString *handicap;
    __unsafe_unretained NSString *marketId;
    __unsafe_unretained NSString *orderType;
    __unsafe_unretained NSString *persistenceType;
    __unsafe_unretained NSString *placedDate;
    __unsafe_unretained NSString *priceSize;
    __unsafe_unretained NSString *price;
    __unsafe_unretained NSString *size;
    __unsafe_unretained NSString *regulatorCode;
    __unsafe_unretained NSString *selectionId;
    __unsafe_unretained NSString *side;
    __unsafe_unretained NSString *sizeCancelled;
    __unsafe_unretained NSString *sizeLapsed;
    __unsafe_unretained NSString *sizeMatched;
    __unsafe_unretained NSString *sizeRemaining;
    __unsafe_unretained NSString *sizeVoided;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *liability;
};

struct BNGPlaceOrderField {
    __unsafe_unretained NSString *customerRef;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *errorCode;
    __unsafe_unretained NSString *marketId;
    __unsafe_unretained NSString *instructionReports;
    __unsafe_unretained NSString *instruction;
    __unsafe_unretained NSString *betId;
    __unsafe_unretained NSString *placedDate;
    __unsafe_unretained NSString *averagePriceMatched;
    __unsafe_unretained NSString *sizeMatched;
    __unsafe_unretained NSString *limitOrder;
    __unsafe_unretained NSString *limitOnCloseOrder;
    __unsafe_unretained NSString *marketOnCloseOrder;
};

struct BNGCancelOrderField {
    __unsafe_unretained NSString *sizeCancelled;
    __unsafe_unretained NSString *cancelledDate;
    __unsafe_unretained NSString *sizeReduction;
};

struct BNGReplaceOrderField {
    __unsafe_unretained NSString *cancelInstructionReport;
    __unsafe_unretained NSString *placeInstructionReport;
};

struct BNGCountryCodeField {
    __unsafe_unretained NSString *countryCode;
    __unsafe_unretained NSString *marketCount;
};

struct BNGCompetitionResultField {
    __unsafe_unretained NSString *competition;
    __unsafe_unretained NSString *competitionRegion;
    __unsafe_unretained NSString *marketCount;
};

static const struct BNGAccountFundsField BNGAccountFundsField = {
    .availableToBetBalance = @"availableToBetBalance",
    .exposure = @"exposure",
    .exposureLimit = @"exposureLimit",
    .retainedCommission = @"retainedCommission",
};

static const struct BNGAccountDetailsField BNGAccountDetailsField = {
    .currencyCode = @"currencyCode",
    .firstName = @"firstName",
    .lastName = @"lastName",
    .localeCode = @"localeCode",
    .region = @"region",
    .timezone = @"timezone",
    .discountRate = @"discountRate",
    .pointsBalance = @"pointsBalance",
};

static const struct BNGEventField BNGEventField = {
    .event = @"event",
    .marketCount = @"marketCount",
    .identifier = @"id",
    .name = @"name",
    .countryCode = @"countryCode",
    .openDate = @"openDate",
    .timezone = @"timezone",
};

static const struct BNGEventTypeResultField BNGEventTypeResultField = {
    .eventType = @"eventType",
    .marketCount = @"marketCount",
};

static const struct BNGEventTypeField BNGEventTypeField = {
    .identifier = @"id",
    .name = @"name",
};

static const struct BNGMarketBookField BNGMarketBookField = {
    .betDelay = @"betDelay",
    .bspReconciled = @"bspReconciled",
    .complete = @"complete",
    .crossMatching = @"crossMatching",
    .inplay = @"inplay",
    .isMarketDataDelayed = @"isMarketDataDelayed",
    .lastMatchTime = @"lastMatchTime",
    .marketId = @"marketId",
    .numberOfActiveRunners = @"numberOfActiveRunners",
    .numberOfRunners = @"numberOfRunners",
    .numberOfWinners = @"numberOfWinners",
    .runners = @"runners",
    .runnersVoidable = @"runnersVoidable",
    .status = @"status",
    .totalAvailable = @"totalAvailable",
    .totalMatched = @"totalMatched",
    .version = @"version",
};

static const struct BNGRunnerField BNGRunnerField = {
    .handicap = @"handicap",
    .lastPriceTraded = @"lastPriceTraded",
    .selectionId = @"selectionId",
    .status = @"status",
    .totalMatched = @"totalMatched",
    .metadata = @"metadata",
    .runnerId = @"runnerId",
    .sortPriority = @"sortPriority",
    .ex = @"ex",
    .sp = @"sp",
    .availableToBack = @"availableToBack",
    .availableToLay = @"availableToLay",
    .tradedVolume = @"tradedVolume",
    .backStakeTaken = @"backStakeTaken",
    .farPrice = @"farPrice",
    .layLiabilityTaken = @"layLiabilityTaken",
    .nearPrice = @"nearPrice",
};

static const struct BNGCompetitionField BNGCompetitionField = {
    .identifier = @"id",
    .name = @"name",
};

static const struct BNGMarketCatalogueField BNGMarketCatalogueField = {
    .competition = @"competition",
    .description = @"description",
    .event = @"event",
    .eventType = @"eventType",
    .marketId = @"marketId",
    .marketName = @"marketName",
    .marketStartTime = @"marketStartTime",
    .runners = @"runners",
};

static const struct BNGMarketCatalogueDescriptionField BNGMarketCatalogueDescriptionField = {
    .bettingType = @"bettingType",
    .bspMarket = @"bspMarket",
    .clarifications = @"clarifications",
    .discountAllowed = @"discountAllowed",
    .marketBaseRate = @"marketBaseRate",
    .marketTime = @"marketTime",
    .marketType = @"marketType",
    .persistenceEnabled = @"persistenceEnabled",
    .regulator = @"regulator",
    .rules = @"rules",
    .rulesHasDate = @"rulesHasDate",
    .settleTime = @"settleTime",
    .suspendTime = @"suspendTime",
    .turnInPlayEnabled = @"turnInPlayEnabled",
    .wallet = @"wallet",
};

static const struct BNGCurrentOrderSummaryReportField BNGCurrentOrderSummaryReportField = {
    .currentOrders = @"currentOrders",
    .moreAvailable = @"moreAvailable",
};

static const struct BNGOrderField BNGOrderField = {
    .averagePriceMatched = @"averagePriceMatched",
    .betId = @"betId",
    .bspLiability = @"bspLiability",
    .handicap = @"handicap",
    .marketId = @"marketId",
    .orderType = @"orderType",
    .persistenceType = @"persistenceType",
    .placedDate = @"placedDate",
    .priceSize = @"priceSize",
    .price = @"price",
    .size = @"size",
    .regulatorCode = @"regulatorCode",
    .selectionId = @"selectionId",
    .side = @"side",
    .sizeCancelled = @"sizeCancelled",
    .sizeLapsed = @"sizeLapsed",
    .sizeMatched = @"sizeMatched",
    .sizeRemaining = @"sizeRemaining",
    .sizeVoided = @"sizeVoided",
    .status = @"status",
    .liability = @"liability",
};

static const struct BNGPlaceOrderField BNGPlaceOrderField = {
    .customerRef = @"customerRef",
    .status = @"status",
    .errorCode = @"errorCode",
    .marketId = @"marketId",
    .instructionReports = @"instructionReports",
    .instruction = @"instruction",
    .betId = @"betId",
    .placedDate = @"placedDate",
    .averagePriceMatched = @"averagePriceMatched",
    .sizeMatched = @"sizeMatched",
    .limitOrder = @"limitOrder",
    .limitOnCloseOrder = @"limitOnCloseOrder",
    .marketOnCloseOrder = @"marketOnCloseOrder",
};

static const struct BNGCancelOrderField BNGCancelOrderField = {
    .sizeCancelled = @"sizeCancelled",
    .cancelledDate = @"cancelledDate",
    .sizeReduction = @"sizeReduction",
};

static const struct BNGReplaceOrderField BNGReplaceOrderField = {
    .cancelInstructionReport = @"cancelInstructionReport",
    .placeInstructionReport = @"placeInstructionReport",
};

static const struct BNGCountryCodeField BNGCountryCodeField = {
    .countryCode = @"countryCode",
    .marketCount = @"marketCount"
};

static const struct BNGCompetitionResultField BNGCompetitionResultField = {
    .competition = @"competition",
    .competitionRegion = @"competitionRegion",
    .marketCount = @"marketCount"
};

@implementation BNGAPIResponseParser

+ (NSArray *)parseBNGEventsFromResponse:(NSArray *)response
{
    NSMutableArray *eventResults = [NSMutableArray array];

    for (id result in response) {
        BNGEventResult * eventResult = [[BNGEventResult alloc] initWithBNGEvent:[BNGAPIResponseParser parseBNGEventFromResponse:result[BNGEventField.event]]
                                                                    marketCount:[result[BNGEventField.marketCount] intValue]];
        [eventResults addObject:eventResult];
    }

    return eventResults;
}

+ (NSArray *)parseBNGMarketBooksFromResponse:(NSArray *)response
{
    NSMutableArray *marketBooks = [NSMutableArray array];

    for (id result in response) {

        [marketBooks addObject:[BNGAPIResponseParser parseBNGMarketBookFromResponse:result]];
    }

    return marketBooks;
}

+ (NSArray *)parseBNGMarketCataloguesFromResponse:(NSArray *)response
{
    NSMutableArray *marketCatalogues = [NSMutableArray array];

    for (id result in response) {

        [marketCatalogues addObject:[BNGAPIResponseParser parseBNGMarketCatalogueFromResponse:result]];
    }

    return marketCatalogues;
}

+ (BNGCurrentOrderSummaryReport *)parseBNGCurrentOrderSummaryReportFromResponse:(NSDictionary *)response
{
    BNGCurrentOrderSummaryReport *report = [[BNGCurrentOrderSummaryReport alloc] init];
    report.currentOrders = [BNGAPIResponseParser parseBNGOrdersFromResponse:response[BNGCurrentOrderSummaryReportField.currentOrders]];
    report.moreAvailable = [response[BNGCurrentOrderSummaryReportField.moreAvailable] boolValue];
    return report;
}

+ (BNGAccountFunds *)parseBNGAccountFundsFromResponse:(NSDictionary *)response
{
    BNGAccountFunds *accountFunds = [[BNGAccountFunds alloc] init];
    accountFunds.availableToBetBalance = [response[BNGAccountFundsField.availableToBetBalance] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    accountFunds.exposure = [response[BNGAccountFundsField.exposure] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    accountFunds.exposureLimit = [response[BNGAccountFundsField.exposureLimit] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    accountFunds.retainedCommission = [response[BNGAccountFundsField.retainedCommission] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    return accountFunds;
}

+ (BNGAccountDetails *)parseBNGAccountDetailsFromResponse:(NSDictionary *)response
{
    BNGAccountDetails *accountDetails = [[BNGAccountDetails alloc] init];
    accountDetails.currencyCode = response[BNGAccountDetailsField.currencyCode];
    accountDetails.firstName = response[BNGAccountDetailsField.firstName];
    accountDetails.lastName = response[BNGAccountDetailsField.lastName];
    accountDetails.localeCode = response[BNGAccountDetailsField.localeCode];
    accountDetails.region = response[BNGAccountDetailsField.region];
    accountDetails.timezone = [NSTimeZone timeZoneWithName:response[BNGAccountDetailsField.timezone]];
    accountDetails.discountRate = [response[BNGAccountDetailsField.discountRate] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    accountDetails.pointsBalance = [response[BNGAccountDetailsField.pointsBalance] integerValue];
    return accountDetails;
}

+ (BNGEvent *)parseBNGEventFromResponse:(NSDictionary *)response
{
    BNGEvent *event = [[BNGEvent alloc] init];
    event.countryCode = response[BNGEventField.countryCode];
    event.eventId = response[BNGEventField.identifier];
    event.name = response[BNGEventField.name];

    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    event.openDate = [dateFormatter dateFromString:response[BNGEventField.openDate]];

    event.timezone = [NSTimeZone timeZoneWithName:response[BNGEventField.timezone]];
    return event;
}

+ (BNGEventTypeResult *)parseBNGEventTypeResultsFromResponse:(NSDictionary *)response
{
    BNGEventTypeResult *eventTypeResult;
    if (response) {
        BNGEventType *eventType = [BNGAPIResponseParser parseBNGEventTypeFromResponse:response[BNGEventTypeResultField.eventType]];
        eventTypeResult = [[BNGEventTypeResult alloc] initWithEventType:eventType
                                                            marketCount:[response[BNGEventTypeResultField.marketCount] integerValue]];
    }
    return eventTypeResult;
}

+ (BNGEventType *)parseBNGEventTypeFromResponse:(NSDictionary *)response
{
    BNGEventType *eventType;
    if (response) {
        eventType = [[BNGEventType alloc] initWithIdentifier:response[BNGEventTypeField.identifier]
                                                        name:response[BNGEventTypeField.name]];
    }
    return eventType;
}

+ (BNGPlaceExecutionReport *)parseBNGPlaceExecutionReportFromResponse:(NSDictionary *)response
{
    BNGPlaceExecutionReport *report = [[BNGPlaceExecutionReport alloc] init];
    [BNGAPIResponseParser parseExecutionReportFromResponse:response intoReport:report];
    report.instructionReports = [BNGAPIResponseParser parseBNGPlaceInstructionReportsFromResponse:response[BNGPlaceOrderField.instructionReports]];
    return report;
}

+ (BNGUpdateExecutionReport *)parseBNGUpdateExecutionReportFromResponse:(NSDictionary *)response
{
    BNGUpdateExecutionReport *report = [[BNGUpdateExecutionReport alloc] init];
    [BNGAPIResponseParser parseExecutionReportFromResponse:response intoReport:report];
    // TODO: Parse out the response.
    return report;
}

+ (BNGCancelExecutionReport *)parseBNGCancelExecutionReportFromResponse:(NSDictionary *)response
{
    BNGCancelExecutionReport *report = [[BNGCancelExecutionReport alloc] init];
    [BNGAPIResponseParser parseExecutionReportFromResponse:response intoReport:report];
    report.instructionReports = [BNGAPIResponseParser parseBNGCancelInstructionReportsFromResponse:response[BNGPlaceOrderField.instructionReports]];
    return report;
}

+ (BNGReplaceExecutionReport *)parseBNGReplaceExecutionReportFromResponse:(NSDictionary *)response
{
    BNGReplaceExecutionReport *report = [[BNGReplaceExecutionReport alloc] init];
    [BNGAPIResponseParser parseExecutionReportFromResponse:response intoReport:report];
    report.instructionReports = [BNGAPIResponseParser parseBNGReplaceInstructionReportsFromResponse:response[BNGPlaceOrderField.instructionReports]];
    return report;
}

+ (NSArray *)parseBNGCompetitionResultsFromResponse:(NSArray *)response
{
    NSMutableArray *competitions = [[NSMutableArray alloc] initWithCapacity:response.count];
    for (NSDictionary *competition in response) {
        [competitions addObject:[BNGAPIResponseParser parseBNGCompetitionResultFromResponse:competition]];
    }
    return [competitions copy];
}

+ (NSArray *)parseBNGCountryCodeResultsFromResponse:(NSArray *)response
{
    NSMutableArray *countryCodes = [[NSMutableArray alloc] initWithCapacity:response.count];
    for (NSDictionary *country in response) {
        [countryCodes addObject:[BNGAPIResponseParser parseBNGCountryCodeResultFromResponse:country]];
    }
    return [countryCodes copy];
}

#pragma mark Private Methods

+ (BNGMarketBook *)parseBNGMarketBookFromResponse:(NSDictionary *)response
{
    BNGMarketBook *marketBook = [[BNGMarketBook alloc] init];
    marketBook.betDelay = [response[BNGMarketBookField.betDelay] integerValue];
    marketBook.BSPReconciled = [response[BNGMarketBookField.bspReconciled] boolValue];
    marketBook.complete = [response[BNGMarketBookField.complete] boolValue];
    marketBook.crossMatching = [response[BNGMarketBookField.crossMatching] boolValue];
    marketBook.inplay = [response[BNGMarketBookField.inplay] boolValue];
    marketBook.marketDataDelayed = [response[BNGMarketBookField.isMarketDataDelayed] boolValue];

    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    marketBook.lastMatchTime = [dateFormatter dateFromString:response[BNGMarketBookField.lastMatchTime]];

    marketBook.marketId = response[BNGMarketBookField.marketId];
    marketBook.numberOfActiveRunners = [response[BNGMarketBookField.numberOfActiveRunners] integerValue];
    marketBook.numberOfRunners = [response[BNGMarketBookField.numberOfRunners] integerValue];
    marketBook.numberOfWinners = [response[BNGMarketBookField.numberOfWinners] integerValue];

    NSMutableArray *marketRunners = [[NSMutableArray alloc] initWithCapacity:marketBook.numberOfRunners];
    NSArray *runners = response[BNGMarketBookField.runners];
    for (id runner in runners) {
        [marketRunners addObject:[BNGAPIResponseParser parseBNGRunnerFromResponse:runner]];
    }
    marketBook.runners = [marketRunners copy];

    marketBook.runnersVoidable = [response[BNGMarketBookField.runnersVoidable] integerValue];
    marketBook.status = [BNGMarketBook marketStatusFromString:response[BNGMarketBookField.status]];
    marketBook.totalAvailable = [response[BNGMarketBookField.totalAvailable] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    marketBook.totalMatched = [response[BNGMarketBookField.totalMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    marketBook.version = [response[BNGMarketBookField.version] longLongValue];

    return marketBook;
}

+ (BNGMarketCatalogue *)parseBNGMarketCatalogueFromResponse:(NSDictionary *)response
{
    BNGMarketCatalogue *catalogue = [[BNGMarketCatalogue alloc] init];
    catalogue.competition = [BNGAPIResponseParser parseBNGCompetitionFromResponse:response[BNGMarketCatalogueField.competition]];
    catalogue.description = [BNGAPIResponseParser parseBNGMarketCatalogueDescriptionFromResponse:response[BNGMarketCatalogueField.description]];
    catalogue.event = [BNGAPIResponseParser parseBNGEventFromResponse:response[BNGMarketCatalogueField.event]];
    catalogue.eventType = [BNGAPIResponseParser parseBNGEventTypeFromResponse:response[BNGMarketCatalogueField.event]];
    catalogue.marketId = response[BNGMarketCatalogueField.marketId];
    catalogue.marketName = response[BNGMarketCatalogueField.marketName];

    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    catalogue.marketStartTime = [dateFormatter dateFromString:response[BNGMarketCatalogueField.marketStartTime]];

    NSArray *runners = response[BNGMarketBookField.runners];
    NSMutableArray *marketCatalogueRunners = [[NSMutableArray alloc] initWithCapacity:runners.count];
    for (id runner in runners) {
        [marketCatalogueRunners addObject:[BNGAPIResponseParser parseBNGRunnerFromResponse:runner]];
    }
    catalogue.runners = [marketCatalogueRunners copy];

    return catalogue;
}

+ (BNGRunner *)parseBNGRunnerFromResponse:(NSDictionary *)response
{
    BNGRunner *runner = [[BNGRunner alloc] init];
    runner.handicap = [response[BNGRunnerField.handicap] decimalNumberWithNumberOfFractionalDigits:DecimalConversionIntegerStyle roundingMode:NSNumberFormatterRoundFloor];
    runner.lastPriceTraded = [response[BNGRunnerField.lastPriceTraded] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    runner.selectionId = [response[BNGRunnerField.selectionId] longLongValue];
    runner.status = [BNGRunner runnerStatusFromString:response[BNGRunnerField.status]];
    runner.sortPriority = [response[BNGRunnerField.sortPriority] integerValue];
    runner.totalMatched = [response[BNGRunnerField.totalMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    runner.metadata = response[BNGRunnerField.metadata];
    if (response[BNGRunnerField.metadata] && response[BNGRunnerField.metadata][BNGRunnerField.runnerId]) {
        runner.runnerId = [response[BNGRunnerField.metadata][BNGRunnerField.runnerId] longLongValue];
    }
    // parse out the exchange prices and liquidity
    id exchangePrices = response[BNGRunnerField.ex];
    if (exchangePrices) {
        runner.exchangePrices = [BNGAPIResponseParser parseBNGExchangePricesFromResponse:exchangePrices];
    }
    // parse out the exchange prices and liquidity
    id startingPrices = response[BNGRunnerField.sp];
    if (startingPrices) {
        runner.startingPrices = [BNGAPIResponseParser parseBNGStartingPricesFromResponse:startingPrices];
    }
    return runner;
}

+ (BNGCompetition *)parseBNGCompetitionFromResponse:(NSDictionary *)response
{
    BNGCompetition *competition;
    if (response) {
        competition = [[BNGCompetition alloc] initWithIdentifier:[response[BNGCompetitionField.identifier] longLongValue]
                                                            name:response[BNGCompetitionField.name]];
    }
    return competition;
}

+ (BNGMarketCatalogueDescription *)parseBNGMarketCatalogueDescriptionFromResponse:(NSDictionary *)response
{
    BNGMarketCatalogueDescription *description;
    if (response) {
        description = [[BNGMarketCatalogueDescription alloc] init];
        description.bettingType = [BNGMarketCatalogueDescription marketBettingTypeFromString:response[BNGMarketCatalogueDescriptionField.bettingType]];
        description.bspMarket = [response[BNGMarketCatalogueDescriptionField.bspMarket] boolValue];
        description.clarifications = response[BNGMarketCatalogueDescriptionField.clarifications];
        description.discountAllowed = [response[BNGMarketCatalogueDescriptionField.discountAllowed] boolValue];
        description.marketBaseRate = [response[BNGMarketCatalogueDescriptionField.marketBaseRate] integerValue];

        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        });
        description.marketTime = [dateFormatter dateFromString:response[BNGMarketCatalogueDescriptionField.marketTime]];

        description.marketType = [BNGMarketCatalogueDescription marketTypeFromString:response[BNGMarketCatalogueDescriptionField.marketType]];
        description.persistenceEnabled = [response[BNGMarketCatalogueDescriptionField.persistenceEnabled] boolValue];
        description.regulator = response[BNGMarketCatalogueDescriptionField.regulator];
        description.rules = response[BNGMarketCatalogueDescriptionField.rules];
        description.rulesHasDate = [response[BNGMarketCatalogueDescriptionField.rulesHasDate] boolValue];
        description.settleTime = [dateFormatter dateFromString:response[BNGMarketCatalogueDescriptionField.settleTime]];
        description.suspendTime = [dateFormatter dateFromString:response[BNGMarketCatalogueDescriptionField.suspendTime]];
        description.turnInPlayEnabled = [response[BNGMarketCatalogueDescriptionField.turnInPlayEnabled] boolValue];
        description.wallet = response[BNGMarketCatalogueDescriptionField.wallet];
    }
    return description;
}

+ (NSArray *)parseBNGOrdersFromResponse:(NSArray *)response
{
    NSMutableArray *orders = [NSMutableArray array];
    if (response) {
        for (id dictionary in response) {
            BNGOrder *order = [BNGAPIResponseParser parseBNGOrderFromResponse:dictionary];
            if (order) {
                [orders addObject:order];
            }
        }
    }
    return [orders copy];
}

+ (BNGOrder *)parseBNGOrderFromResponse:(NSDictionary *)response
{
    BNGOrder *order;
    if (response) {
        order = [[BNGOrder alloc] init];
        order.avgPriceMatched = [response[BNGOrderField.averagePriceMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.betId = response[BNGOrderField.betId];
        order.bspLiability = [response[BNGOrderField.bspLiability] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.handicap = [response[BNGOrderField.handicap] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.marketId = response[BNGOrderField.marketId];
        order.orderType = [BNGOrder orderTypeFromString:response[BNGOrderField.orderType]];
        order.persistenceType = [BNGOrder persistenceTypeFromString:response[BNGOrderField.persistenceType]];

        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        });
        order.placedDate = [dateFormatter dateFromString:response[BNGOrderField.placedDate]];

        order.priceSize = [[BNGPriceSize alloc] initWithPrice:[response[BNGOrderField.priceSize][BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]
                                                         size:[response[BNGOrderField.priceSize][BNGOrderField.size] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]];
        order.regulatorCode = response[BNGOrderField.regulatorCode];
        order.selectionId = [response[BNGOrderField.selectionId] longLongValue];
        order.side = [BNGOrder sideFromString:response[BNGOrderField.side]];
        order.sizeCancelled = [response[BNGOrderField.sizeCancelled] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.sizeLapsed = [response[BNGOrderField.sizeLapsed] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.sizeMatched = [response[BNGOrderField.sizeMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.sizeRemaining = [response[BNGOrderField.sizeRemaining] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.sizeVoided = [response[BNGOrderField.sizeVoided] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
        order.status = [BNGOrder orderStatusFromString:response[BNGOrderField.status]];
    }
    return order;
}

+ (void)parseExecutionReportFromResponse:(NSDictionary *)response intoReport:(BNGExecutionReport *)report
{
    report.customerRef = response[BNGPlaceOrderField.customerRef];
    report.status = [BNGExecutionReport executionReportStatusFromString:response[BNGPlaceOrderField.status]];
    report.errorCode = [BNGExecutionReport executionReportErrorCodeFromString:response[BNGPlaceOrderField.errorCode]];
    report.marketId = response[BNGPlaceOrderField.marketId];
}

+ (NSArray *)parseBNGPlaceInstructionReportsFromResponse:(NSArray *)response
{
    NSMutableArray *instructions = [NSMutableArray arrayWithCapacity:response.count];
    if (response) {
        for (NSDictionary *instruction in response) {
            [instructions addObject:[BNGAPIResponseParser parseBNGPlaceInstructionReportFromInstruction:instruction]];
        }
    }
    return [instructions copy];
}

+ (BNGPlaceInstructionReport *)parseBNGPlaceInstructionReportFromInstruction:(NSDictionary *)instruction
{
    BNGPlaceInstructionReport *report = [[BNGPlaceInstructionReport alloc] init];
    [BNGAPIResponseParser parseBNGInstructionReportFromInstruction:instruction intoReport:report];
    report.instruction = [BNGAPIResponseParser parseBNGPlaceInstructionFromResponse:instruction[BNGPlaceOrderField.instruction]];
    report.betId = instruction[BNGPlaceOrderField.betId];

    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    report.placedDate = [dateFormatter dateFromString:instruction[BNGPlaceOrderField.placedDate]];

    report.averagePriceMatched = [instruction[BNGPlaceOrderField.averagePriceMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    report.sizeMatched = [instruction[BNGPlaceOrderField.sizeMatched] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    return report;
}

+ (NSArray *)parseBNGCancelInstructionReportsFromResponse:(NSArray *)response
{
    NSMutableArray *instructions = [NSMutableArray arrayWithCapacity:response.count];
    if (response) {
        for (NSDictionary *instruction in response) {
            [instructions addObject:[BNGAPIResponseParser parseBNGCancelInstructionReportFromInstruction:instruction]];
        }
    }
    return [instructions copy];
}

+ (BNGCancelInstructionReport *)parseBNGCancelInstructionReportFromInstruction:(NSDictionary *)instruction
{
    BNGCancelInstructionReport *report = [[BNGCancelInstructionReport alloc] init];
    [BNGAPIResponseParser parseBNGInstructionReportFromInstruction:instruction intoReport:report];
    report.cancelInstruction = [BNGAPIResponseParser parseBNGCancelInstructionFromResponse:instruction[BNGPlaceOrderField.instruction]];

    if (instruction[BNGCancelOrderField.cancelledDate]) {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        });
        report.cancelledDate = [dateFormatter dateFromString:instruction[BNGCancelOrderField.cancelledDate]];
    }

    report.sizeCancelled = [instruction[BNGCancelOrderField.sizeCancelled] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    return report;
}

+ (NSArray *)parseBNGReplaceInstructionReportsFromResponse:(NSArray *)response
{
    NSMutableArray *instructions = [NSMutableArray arrayWithCapacity:response.count];
    if (response) {
        for (NSDictionary *instruction in response) {
            BNGReplaceInstructionReport *report = [[BNGReplaceInstructionReport alloc] init];
            [BNGAPIResponseParser parseBNGInstructionReportFromInstruction:instruction intoReport:report];
            report.cancelInstructionReport = [BNGAPIResponseParser parseBNGCancelInstructionReportFromInstruction:instruction[BNGReplaceOrderField.cancelInstructionReport]];
            report.placeInstructionReport = [BNGAPIResponseParser parseBNGPlaceInstructionReportFromInstruction:instruction[BNGReplaceOrderField.placeInstructionReport]];
            [instructions addObject:report];
        }
    }
    return [instructions copy];
}

+ (void)parseBNGInstructionReportFromInstruction:(NSDictionary *)instruction intoReport:(BNGInstructionReport *)report
{
    report.status = [BNGInstructionReport instructionReportStatusFromString:instruction[BNGPlaceOrderField.status]];
    report.errorCode = [BNGInstructionReport instructionReportErrorCodeFromString:instruction[BNGPlaceOrderField.errorCode]];
}

+ (BNGPlaceInstruction *)parseBNGPlaceInstructionFromResponse:(NSDictionary *)response
{
    BNGPlaceInstruction *instruction;
    if (response) {
        instruction = [[BNGPlaceInstruction alloc] init];
        instruction.orderType = [BNGOrder orderTypeFromString:response[BNGOrderField.orderType]];
        instruction.selectionId = [response[BNGOrderField.selectionId] longLongValue];
        instruction.handicap = [response[BNGOrderField.handicap] decimalNumberWithNumberOfFractionalDigits:DecimalConversionIntegerStyle roundingMode:NSNumberFormatterRoundFloor];
        instruction.side = [BNGOrder sideFromString:response[BNGOrderField.side]];
        instruction.limitOrder = [BNGAPIResponseParser parseBNGLimitOrderFromResponse:response[BNGPlaceOrderField.limitOrder]];
        instruction.limitOnCloseOrder = [BNGAPIResponseParser parseBNGLimitOnCloseOrderFromResponse:response[BNGPlaceOrderField.limitOnCloseOrder]];
        instruction.marketOnCloseOrder = [BNGAPIResponseParser parseBNGMarketOnCloseOrderFromResponse:response[BNGPlaceOrderField.marketOnCloseOrder]];
    }
    return instruction;
}

+ (BNGCancelInstruction *)parseBNGCancelInstructionFromResponse:(NSDictionary *)response
{
    BNGCancelInstruction *instruction;
    if (response) {
        instruction = [[BNGCancelInstruction alloc] initWithBetId:response[BNGOrderField.betId]
                                                    sizeReduction:response[BNGCancelOrderField.sizeReduction]];
    }
    return instruction;
}

+ (BNGLimitOrder *)parseBNGLimitOrderFromResponse:(NSDictionary *)response
{
    BNGLimitOrder *limitOrder;
    if (response) {
        limitOrder.priceSize = [[BNGPriceSize alloc] initWithPrice:[response[BNGOrderField.priceSize][BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]
                                                              size:[response[BNGOrderField.priceSize][BNGOrderField.size] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]];
        limitOrder.persistenceType = [BNGOrder persistenceTypeFromString:response[BNGOrderField.persistenceType]];
    }
    return limitOrder;
}

+ (BNGLimitOnCloseOrder *)parseBNGLimitOnCloseOrderFromResponse:(NSDictionary *)response
{
    BNGLimitOnCloseOrder *limitOnCloseOrder;
    if (response) {
        limitOnCloseOrder = [[BNGLimitOnCloseOrder alloc] initWithPrice:[response[BNGOrderField.priceSize][BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]
                                                              liability:[response[BNGOrderField.priceSize][BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]];
    }
    return limitOnCloseOrder;
}

+ (BNGMarketOnCloseOrder *)parseBNGMarketOnCloseOrderFromResponse:(NSDictionary *)response
{
    BNGMarketOnCloseOrder *marketOnCloseOrder;
    if (response) {
        marketOnCloseOrder = [[BNGMarketOnCloseOrder alloc] initWithLiability:[response[BNGOrderField.priceSize][BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]];
    }
    return marketOnCloseOrder;
}

+ (BNGExchangePrices *)parseBNGExchangePricesFromResponse:(NSDictionary *)response
{
    BNGExchangePrices *exchangePrices = [[BNGExchangePrices alloc] init];
    exchangePrices.availableToBack = [BNGAPIResponseParser parseBNGPricesFromResponse:response[BNGRunnerField.availableToBack]];
    exchangePrices.availableToLay = [BNGAPIResponseParser parseBNGPricesFromResponse:response[BNGRunnerField.availableToLay]];
    exchangePrices.tradedVolume = [BNGAPIResponseParser parseBNGPricesFromResponse:response[BNGRunnerField.tradedVolume]];
    return exchangePrices;
}

+ (BNGStartingPrices *)parseBNGStartingPricesFromResponse:(NSDictionary *)response
{
    BNGStartingPrices *startingPrices = [[BNGStartingPrices alloc] init];
    startingPrices.backStakeTaken = [BNGAPIResponseParser parseBNGPricesFromResponse:response[BNGRunnerField.backStakeTaken]];
    startingPrices.farPrice = [response[BNGRunnerField.farPrice] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    startingPrices.layLiabilityTaken = [BNGAPIResponseParser parseBNGPricesFromResponse:response[BNGRunnerField.layLiabilityTaken]];
    startingPrices.nearPrice = [response[BNGRunnerField.nearPrice] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor];
    return startingPrices;
}

+ (NSArray *)parseBNGPricesFromResponse:(NSArray *)response
{
    NSMutableArray *prices = [NSMutableArray array];
    for (id price in response) {
        [prices addObject:[[BNGPriceSize alloc] initWithPrice:[price[BNGOrderField.price] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]
                                                         size:[price[BNGOrderField.size] decimalNumberWithNumberOfFractionalDigits:DecimalConversionMoneyStyle roundingMode:NSNumberFormatterRoundFloor]]];
    }
    return prices;
}

+ (BNGCountryCodeResult *)parseBNGCountryCodeResultFromResponse:(NSDictionary *)response
{
    BNGCountryCodeResult *countryCodeResult = [[BNGCountryCodeResult alloc] init];
    countryCodeResult.countryCode = [[BNGCountryCode alloc] initWithCountryCodeName:response[BNGCountryCodeField.countryCode]];
    countryCodeResult.marketCount = [response[BNGCountryCodeField.marketCount] intValue];
    return countryCodeResult;
}

+ (BNGCompetitionResult *)parseBNGCompetitionResultFromResponse:(NSDictionary *)response
{
    BNGCompetitionResult *competitionResult = [[BNGCompetitionResult alloc] init];
    competitionResult.marketCount = [response[BNGCompetitionResultField.marketCount] intValue];
    competitionResult.competitionRegion = response[BNGCompetitionResultField.competitionRegion];
    competitionResult.competition = [BNGAPIResponseParser parseBNGCompetitionFromResponse:response[BNGCompetitionResultField.competition]];
    return competitionResult;
}

@end
