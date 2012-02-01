#import "CalculateViewController.h"
#import "ProblemAnswer.h"
#import "ColorPickerViewController.h"

@interface CalculateViewController()
@property float favouriteHue;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) ColorPickerViewController *colorPickerViewController;
-(void)newProblem;
@end

@implementation CalculateViewController
@synthesize number1=_number1;
@synthesize number2=_number2;
@synthesize favouriteHue;
@synthesize results;
@synthesize colorPickerViewController;

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
    
    NSLog(@"correct: %d", correct);
    NSLog(@"total: %d", total);
    NSLog(@"percent %f", ((float) correct) / ((float) total));
    NSLog(@"----------------------------------");
    
    return ((float) correct) / ((float) total);
}

-(void)updateColorsInView
{
    
    float percentCorrect;
    if (self.results.count == 0) {
        percentCorrect = 1.0;
    } else {
        percentCorrect = [self percentCorrectOfLast:5];
    }
    
    NSLog(@"Percent correct: %f", percentCorrect);
    float hue = self.favouriteHue + (1.0 - percentCorrect) * 0.5; 
    if (hue > 1.0) {
        hue = hue - 1.0;
    }
    UIColor *backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:0.3 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    problemLabel.textColor = color;
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
    [self updateColorsInView];
    [answerField becomeFirstResponder];
    self.favouriteHue = 0.66666;
    
    colorPickerViewController = [[ColorPickerViewController alloc] initWithDelegate:self];
    [self.view addSubview:self.colorPickerViewController.view];
    CGRect frame = self.colorPickerViewController.view.frame;
    frame = CGRectOffset(frame, (self.view.frame.size.height - frame.size.width) / 2.0, 0);
    self.colorPickerViewController.view.frame = frame;
}

- (void)viewDidUnload
{
    answerField = nil;
    equalsLabel = nil;
    underscoreView = nil;
    problemLabel = nil;
    [super viewDidUnload];
}

-(int)randomNumber{
    return arc4random() % 10;
}

- (void)newProblem{
    self.number1 = [self randomNumber];
    self.number2 = [self randomNumber];
    
    problemLabel.text = [NSString stringWithFormat:@"%d + %d", self.number1, self.number2];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)answerEntered:(id)sender {
}

-(void)checkAnswer {
    int answerAsInt = answerField.text.integerValue;
    if (answerAsInt == 0 && ![answerField.text isEqualToString:@"0"]) {
        answerAsInt = -1;
    }
    ProblemAnswer *answer = [[ProblemAnswer alloc] initWithLeftHandSide:self.number1 withRightHandSide:self.number2 andAnswer:answerAsInt];
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

-(void)valueDidChange:(float)value {
    self.favouriteHue = value;
    [self updateColorsInView];
}
@end

