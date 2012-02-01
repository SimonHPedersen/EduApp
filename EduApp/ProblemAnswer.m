#import "ProblemAnswer.h"

@interface ProblemAnswer ()
@property int leftHandSide;
@property int rightHandSide;
@property int answer;
@end

@implementation ProblemAnswer

@synthesize leftHandSide = _leftHandSide;
@synthesize rightHandSide = _rightHandSide;
@synthesize answer = _answer;

-(id)initWithLeftHandSide:(int)leftHandSide withRightHandSide:(int)rightHandSide andAnswer:(int)answer {
    self = [super init];
    if (self) {
        self.leftHandSide = leftHandSide;
        self.rightHandSide = rightHandSide;
        self.answer = answer;
    }
    return self;
}

-(BOOL)isCorrect {
    return self.leftHandSide + self.rightHandSide == self.answer;
}

@end
