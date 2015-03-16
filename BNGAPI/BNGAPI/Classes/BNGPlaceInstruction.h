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

#import "BNGOrder.h"
#import "BNGDictionaryRepresentation.h"

#import "BNGLimitOrder.h"
#import "BNGLimitOnCloseOrder.h"
#import "BNGMarketOnCloseOrder.h"

/**
 * Details a betting instruction. A `BNGPlaceInstruction` is typically passed to all betting APIs.
 */
@interface BNGPlaceInstruction : NSObject <BNGDictionaryRepresentation>

@property (nonatomic) BNGOrderType orderType;

/**
 * Unique identifier for the `BNGRunner` on which the `BNGPlaceInstruction` is focused.
 */
@property (nonatomic) long long selectionId;

/**
 * The handicap applied to the selection, if on an asian-style market.
 */
@property (nonatomic) NSDecimalNumber *handicap;

/**
 * Dictates whether this `BNGPlaceInstruction` will be a back or lay bet.
 */
@property (nonatomic) BNGSide side;

/**
 * Limit Order associated with this place instruction. A Limit Order is a regular exchange bet instruction.
 */
@property (nonatomic) BNGLimitOrder *limitOrder;

/**
 * `BNGLimitOnCloseOrder` associated with this place instruction. It's not 100% necessary that this property
 * be set for a bet to be placed.
 */
@property (nonatomic) BNGLimitOnCloseOrder *limitOnCloseOrder;

/**
 * `BNGMarketOnCloseOrder` associated with this place instruction. It's not 100% necessary that this property
 * be set for a bet to be placed.
 */
@property (nonatomic) BNGMarketOnCloseOrder *marketOnCloseOrder;

/**
 * Given a collection of `BNGPlaceInstruction`s, this method returns a fully-formed
 * NSDictionary representation of these instructions.
 * @param placeInstructions collection of `BNGPlaceInstruction`s
 * @return a collection of NSDictionary representations corresponding to the placeInstructions parameter.
 */
+ (NSArray *)dictionaryRepresentationsForBNGPlaceInstructions:(NSArray *)placeInstructions;

@end