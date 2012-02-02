#import "CalculateViewController.h"
#import "Answer.h"
#import "ColorPickerViewController.h"
#import "AdaptiveStrategy.h"
#import "ConfigurationViewController.h"
#import "Audio.h"
@interface CalculateViewController()
@property float favouriteHue;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) ColorPickerViewController *colorPickerViewController;
@property (strong, nonatomic) AdaptiveStrategy *adaptiveStrategy;
@property (strong, nonatomic) ConfigurationViewController *configurationViewController;
@property (strong, nonatomic) NumericalKeyboardController * numericKeyBoardController;
@property (strong, nonatomic) Audio *audio;

-(void)newProblem;
@end

@implementation CalculateViewController
@synthesize favouriteHue;
@synthesize results;
@synthesize colorPickerViewController;
@synthesize question;
@synthesize adaptiveStrategy;
@synthesize configurationViewController;
@synthesize numericKeyBoardController;
@synthesize audio;

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

-(void)updateAudio
{
    float percentCorrect;
    if(self.results.count == 0){
        percentCorrect = 1.0;
    } else {
        percentCorrect = [self percentCorrectOfLast:5];
    }
    float level = 1-percentCorrect;
    [audio effectLevel:level * 100.0f];
}

-(void)updateColorsInView:(BOOL)animate
{
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    problemLabel.textColor = color;
    equalsLabel.textColor = color;
    answerLabel.textColor = color;
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
    [self newProblem];
    [self updateColorsInView:NO];
    self.favouriteHue = 0.66666;

    self.configurationViewController = [[ConfigurationViewController alloc] initWithParent:self];
    self.numericKeyBoardController = [[NumericalKeyboardController alloc] initWithDelegate:self];
    CGRect numericalKeyboardFrame = self.numericKeyBoardController.view.frame;
    numericalKeyboardFrame = CGRectOffset(numericalKeyboardFrame, 0, 768 - numericalKeyboardFrame.size.height);
    self.numericKeyBoardController.view.frame = numericalKeyboardFrame;
    
    [self.view addSubview:self.numericKeyBoardController.view];
    
    self.audio = [[Audio alloc] init];
    [self.audio start];
}

- (void)viewDidUnload
{
    equalsLabel = nil;
    underscoreView = nil;
    problemLabel = nil;
    answerLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)checkAnswer:(int)answerAsInt {
    Answer *answer = [[Answer alloc] initWithQuestion:self.question andAnswer:answerAsInt];
    [self.results addObject:answer];
}

-(void)valueDidChange:(float)value {
    self.favouriteHue = value;
    [self updateColorsInView:NO];
}

- (IBAction)informationTouched:(id)sender {
    [self.view addSubview:self.configurationViewController.view];
}

-(void)numberPressed:(int)number{
    answerLabel.text = [NSString stringWithFormat:@"%@%d", answerLabel.text, number];
}

-(void)clearAnswer {
    answerLabel.text = @"";    
}
-(void)submitPressed{
    if (![answerLabel.text isEqualToString:@""])
    {
        int answer = answerLabel.text.integerValue;
        
        [self checkAnswer:answer];
        [self updateColorsInView:YES];
        [self updateAudio];
        [self newProblem];
        [self clearAnswer];
    }
}

-(void)clearTouched {
    [self clearAnswer];
}

@end