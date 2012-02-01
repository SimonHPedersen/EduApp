#import "AdaptiveStrategy.h"
#import "Answer.h"

@interface AdaptiveStrategy ()
@property int leftOperandDigits;
@property int rightOperandDigits;
@property int sinceLastChange;
@end

@implementation AdaptiveStrategy
@synthesize leftOperandDigits;
@synthesize rightOperandDigits;
@synthesize sinceLastChange;

-(id)init {
    self = [super init];
    if (self)
    {
        self.leftOperandDigits = 1;
        self.rightOperandDigits = 1;
        self.sinceLastChange = 0;
    }
    return self;
}

-(int)randomNumberWithDigits:(int)digits{
    return arc4random() % (int) pow(10, digits);
}

-(int)numberOfCorrectAnswersInWindow:(int)windowSize forAnswers:(NSArray *)answers;
{
    int correct = 0;
    int total = 0;
    
    for (int i = [answers count] - 1; i >= 0 && total < windowSize; i--)
    {
        total++;
        Answer *answer = [answers objectAtIndex:i];
        if (answer.isCorrect) {
            correct++;
        }
    }

    return correct;
}

- (void)raiseLevel
{
    self.sinceLastChange = 0;
    
    if (self.leftOperandDigits == self.rightOperandDigits)
    {
        self.leftOperandDigits++;
    }
    else
    {
        self.rightOperandDigits++;
    }
}

- (void)lowerLevel
{
    self.sinceLastChange = 0;

    if (self.leftOperandDigits == self.rightOperandDigits)
    {
        self.rightOperandDigits--;
    }
    else
    {
        self.leftOperandDigits--;
    }
    if (self.leftOperandDigits == 0)
    {
        self.leftOperandDigits = 1;
    }
}

-(void)adjustOperandDigitsBasedOnHistory:(NSArray *)history
{
    if (history.count > 5 && self.sinceLastChange > 5)
    {
        // if last 5 are correct, raise level
        if ([self numberOfCorrectAnswersInWindow:5 forAnswers:history] == 5)
        {
            [self raiseLevel];
        }
        
        // if 2 (or less) out 5 last are correct, lower level
        if ([self numberOfCorrectAnswersInWindow:5 forAnswers:history] < 3)
        {
            [self lowerLevel];
        }
    }
}

-(Question*)nextQuestion:(NSArray*)history {
    [self adjustOperandDigitsBasedOnHistory:history];
    
    Question* question = [[Question alloc] initWithLeftOperand:[self randomNumberWithDigits:self.leftOperandDigits] 
                                               andRightOperand:[self randomNumberWithDigits:self.rightOperandDigits]];
    
    self.sinceLastChange++;
    
    return question;
}

@end
