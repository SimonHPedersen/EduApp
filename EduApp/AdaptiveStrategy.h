#import <Foundation/Foundation.h>
#import "Question.h"

@interface AdaptiveStrategy : NSObject

-(Question*)nextQuestion:(NSArray*)history;

@end
