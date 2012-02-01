#import "CalculateViewController.h"
#import "ProblemAnswer.h"

@interface CalculateViewController()
@property float favouriteHue;
@property (strong, nonatomic) NSMutableArray *results;
-(void)newProblem;
@end

@implementation CalculateViewController
@synthesize number1=_number1;
@synthesize number2=_number2;
@synthesize favouriteHue;
@synthesize results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) 
    {
    }
    return self;
}

-(float)percentCorrectOfLast:(int)windowSize {
    int correct = 0;
    int total = 0;
    
    for (int i = [self.results count] - 1; i >= 0 && total < windowSize; i--)
    {
        total++;
        ProblemAnswer *answer = [self.results objectAtIndex:i];
        if (answer.isCorrect) {
            correct++;
        }
    }
    
    return ((float) correct) / ((float) total);
}

-(void)updateColorsInView
{
    self.favouriteHue = 0.66666;
    
    float percentCorrect = [self percentCorrectOfLast:5];
    NSLog(@"Percent correct: %f", percentCorrect);
    float hue = self.favouriteHue + (1.0 - percentCorrect) * 0.5; 
    if (hue > 1.0) {
        hue = hue - 1.0;
    }
    UIColor *backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:0.3 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    number1Label.textColor = color;
    number2Label.textColor = color;
    operatorLabel.textColor = color;
    equalsLabel.textColor = color;
    answerField.textColor = color;
    underscoreView.backgroundColor = color;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.results = [[NSMutableArray alloc] init];

    answerField.delegate = self;
    
    [self newProblem];
}

- (void)viewDidUnload
{
    operatorLabel = nil;
    number1Label = nil;
    number2Label = nil;
    answerField = nil;
    equalsLabel = nil;
    underscoreView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(int)randomNumber{
    return arc4random() % 10;
}

- (void)newProblem{
    self.number1 = [self randomNumber];
    self.number2 = [self randomNumber];
    
    number1Label.text = [NSString stringWithFormat:@"%d", self.number1];
    number2Label.text = [NSString stringWithFormat:@"%d", self.number2];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)answerEntered:(id)sender {
}

-(void)checkAnswer {
    ProblemAnswer *answer = [[ProblemAnswer alloc] initWithLeftHandSide:self.number1 withRightHandSide:self.number2 andAnswer:answerField.text.integerValue];
    [self.results addObject:answer];
    
    if (answer.isCorrect) {
        NSLog(@"Answer was right");
    } else {
        NSLog(@"Answer was !right");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString* answer = answerField.text;
    
    NSLog(@"%@",answer);
    
    [self checkAnswer];
    [self updateColorsInView];
    [self newProblem];

    answerField.text = @"";
    
    return NO;
}
@end
