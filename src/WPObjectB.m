//
//  WPObjectB.m
//  WPObjectB
//
//  Created by R. Tony Goold on 2015-10-07.
//  Copyright © 2015 Wattpad. All rights reserved.
//

#import "WPLibB/WPObjectB.h"

@implementation WPObjectB

- (nonnull instancetype)initWithName:(nonnull NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
    }
    return self;
}

- (nonnull instancetype)init {
    return [self initWithName:@""];
}

@end
