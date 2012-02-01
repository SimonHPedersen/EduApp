#import <Foundation/Foundation.h>
#import "Question.h"

@interface Answer : NSObject
-initWithQuestion:(Question*)question andAnswer:(int)answer;
-(BOOL)isCorrect;
@end
