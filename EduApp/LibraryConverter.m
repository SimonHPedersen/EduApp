//
//  LibraryConverter.m
//  EduApp
//
//  Created by Mikkel Gravgaard on 02/02/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import "LibraryConverter.h"

@implementation LibraryConverter
@synthesize delegate;

- (void)convert:(MPMediaItem *)item
{
    [delegate conversionDidFinish:[[NSBundle mainBundle] pathForResource:@"funny1" ofType:@"mp3"]];
}

@end
