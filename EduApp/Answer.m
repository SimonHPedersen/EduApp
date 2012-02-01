#import "Answer.h"

@interface Answer ()
@property (strong, nonatomic) Question *question;
@property int answer;
@end

@implementation Answer

@synthesize answer = _answer;
@synthesize question = _question;

-initWithQuestion:(Question*)question andAnswer:(int)answer {
    self = [super init];
    if (self) {
        self.question = question;
        self.answer = answer;
    }
    return self;
}

-(BOOL)isCorrect {
    return self.question.leftOperand + self.question.rightOperand == self.answer;
}

@end
