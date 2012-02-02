//
//  LibraryConverter.h
//  EduApp
//
//  Created by Mikkel Gravgaard on 02/02/12.
//  Copyright (c) 2012 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol LibraryConverterDelegate
- (void) conversionDidFinish:(NSString *)songUrl;
- (void) conversionDidProgress:(float)progress;
@end

@interface LibraryConverter : NSObject
@property (weak, nonatomic) id<LibraryConverterDelegate> delegate;
- (void)convert:(MPMediaItem *)item;

@end
