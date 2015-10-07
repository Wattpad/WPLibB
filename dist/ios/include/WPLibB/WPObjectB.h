//
//  WPObjectB.h
//  WPObjectB
//
//  Created by R. Tony Goold on 2015-10-07.
//  Copyright © 2015 Wattpad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPObjectB : NSObject

- (nonnull instancetype)initWithName:(nonnull NSString *)name;

@property (nonatomic, copy, nonnull) NSString *name;

@end
