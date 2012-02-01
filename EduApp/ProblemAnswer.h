#import <Foundation/Foundation.h>

@interface ProblemAnswer : NSObject
-initWithLeftHandSide:(int)leftHandSide withRightHandSide:(int)rightHandSide andAnswer:(int)answer;
-(BOOL)isCorrect;
@end
