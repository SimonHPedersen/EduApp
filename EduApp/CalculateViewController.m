#import "CalculateViewController.h"
#import "Answer.h"
#import "ColorPickerViewController.h"
#import "AdaptiveStrategy.h"

@interface CalculateViewController()
@property float favouriteHue;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) ColorPickerViewController *colorPickerViewController;
@property (strong, nonatomic) AdaptiveStrategy *adaptiveStrategy;
-(void)newProblem;
@end

@implementation CalculateViewController
@synthesize favouriteHue;
@synthesize results;
@synthesize colorPickerViewController;
@synthesize question;
@synthesize adaptiveStrategy;

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
        Answer *answer = [self.results objectAtIndex:i];
        if (answer.isCorrect) {
            correct++;
        }
    }
    
    return ((float) correct) / ((float) total);
}

-(void)updateColorsInView:(BOOL)animate
{
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    problemLabel.textColor = color;
    equalsLabel.textColor = color;
    answerField.textColor = color;
    underscoreView.backgroundColor = color;

    float percentCorrect;
    if (self.results.count == 0) {
        percentCorrect = 1.0;
    } else {
        percentCorrect = [self percentCorrectOfLast:5];
    }
    
    float hue = self.favouriteHue + (1.0 - percentCorrect) * 0.5; 
    if (hue > 1.0) {
        hue = hue - 1.0;
    }
    UIColor *backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:0.3 alpha:1.0];
    
    CGFloat duration = 0.0;
    if (animate)
    {
        duration = 0.5;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.view.backgroundColor = backgroundColor;
    }];
}

-(void)newProblem{
    self.question = [self.adaptiveStrategy nextQuestion:self.results];
    problemLabel.text = [self.question questionText];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adaptiveStrategy = [[AdaptiveStrategy alloc] init];

    self.results = [[NSMutableArray alloc] init];
    answerField.delegate = self;
    [self newProblem];
    [self updateColorsInView:NO];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)checkAnswer {
    int answerAsInt = answerField.text.integerValue;
    if (answerAsInt == 0 && ![answerField.text isEqualToString:@"0"]) {
        answerAsInt = -1;
    }
    Answer *answer = [[Answer alloc] initWithQuestion:self.question andAnswer:answerAsInt];
    [self.results addObject:answer];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkAnswer];
    [self updateColorsInView:YES];
    [self newProblem];

    answerField.text = @"";
    return NO;
}

-(void)valueDidChange:(float)value {
    self.favouriteHue = value;
    [self updateColorsInView:NO];
}
@end