#import "CalculateViewController.h"

@interface CalculateViewController()
@property float favouriteHue;
-(void)newProblem;
@end


@implementation CalculateViewController
@synthesize number1=_number1;
@synthesize number2=_number2;
@synthesize rightCounter,totalCounter;
@synthesize favouriteHue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

-(void)updateColorsInView
{
    self.favouriteHue = 0.66666;
    
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    number1Label.textColor = color;
    number2Label.textColor = color;
    operatorLabel.textColor = color;
    equalsLabel.textColor = color;
    answerField.textColor = color;
    underscoreView.backgroundColor = color;
    
    UIColor *backgroundColor = [UIColor colorWithHue:self.favouriteHue saturation:1 brightness:0.3 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

-(BOOL)isAnswerCorrect {
    return self.number1 + self.number2 == answerField.text.integerValue;
}

-(void)checkAnswer {
    self.totalCounter++;
    if ([self isAnswerCorrect]) {
        NSLog(@"Answer was right");
        self.rightCounter++;
    } else {
        NSLog(@"Answer was !right");
    }
    NSLog(@"Percentage right: %d", (100 * self.rightCounter) / self.totalCounter);
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
