// Copyright (c) 2013 - 2015 The Sporting Exchange Limited
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

#import "BNGPlaceInstruction.h"

#import "BNGAPIResponseParser.h"

@implementation BNGPlaceInstruction

#pragma mark - BNGDictionaryRepresentation

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary dictionary];
    
    if (self.orderType != BNGOrderTypeLimitUnknown) {
        dictionaryRepresentation[@"orderType"] = [BNGOrder stringFromOrderType:self.orderType];
    }
    
    dictionaryRepresentation[@"selectionId"] = @(self.selectionId);
    
    if (self.handicap && ![self.handicap isEqual:[NSDecimalNumber zero]]) {
        // TODO: NSNumberFormatter
        dictionaryRepresentation[@"handicap"] = [NSString stringWithFormat:@"%.2f", [self.handicap doubleValue]];
    }
    
    dictionaryRepresentation[@"side"] = [BNGOrder stringFromSide:self.side];
    
    if (self.limitOrder) {
        dictionaryRepresentation[@"limitOrder"] = self.limitOrder.dictionaryRepresentation;
    }
    
    if (self.limitOnCloseOrder) {
        dictionaryRepresentation[@"limitOnCloseOrder"] = self.limitOnCloseOrder.dictionaryRepresentation;
    }
    
    if (self.marketOnCloseOrder) {
        dictionaryRepresentation[@"marketOnCloseOrder"] = self.marketOnCloseOrder.dictionaryRepresentation;
    }
    
    return dictionaryRepresentation;
}

+ (NSArray *)dictionaryRepresentationsForBNGPlaceInstructions:(NSArray *)placeInstructions
{
    NSParameterAssert(placeInstructions.count);
    
    if (!placeInstructions.count) return nil;
    
    NSMutableArray *representations = [[NSMutableArray alloc] initWithCapacity:placeInstructions.count];
    for (BNGPlaceInstruction *instruction in placeInstructions) {
        [representations addObject:instruction.dictionaryRepresentation];
    }
    return [representations copy];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ BNGPlaceInstruction [orderType %@] [selectionId %lld] [handicap %@] [side %@] [limitOrder %@] [limitOnCloseOrder %@] [marketOnCloseOrder %@]", [super description], [BNGOrder stringFromOrderType:self.orderType], self.selectionId, self.handicap, [BNGOrder stringFromSide:self.side], self.limitOrder, self.limitOnCloseOrder, self.marketOnCloseOrder];
}

@end
