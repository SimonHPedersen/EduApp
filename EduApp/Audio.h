//
//  Audio.h
//  fxprocessor
//
//  Created by Mikkel Gravgaard on 01/02/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Audio : NSOperation

- (void) start:(NSString *)url;

- (void) stop;

- (void)effectLevel:(float) value;

- (void)speed:(float)value;

@end
