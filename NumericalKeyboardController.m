#import "NumericalKeyboardController.h"
@interface NumericalKeyboardController ()
@property (strong, nonatomic) id<NumericKeyboardDelegate> numericKeyboardDelegate;
@end


@implementation NumericalKeyboardController
@synthesize numericKeyboardDelegate;

- (id)initWithDelegate:(id<NumericKeyboardDelegate>)numericKeyboarDelegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.numericKeyboardDelegate = numericKeyboarDelegate;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)submitAnswer:(id)sender {
    [numericKeyboardDelegate submitPressed];
}

- (IBAction)numberPressed:(id)sender {
    UIButton *numberButton = (UIButton*) sender;
    [numericKeyboardDelegate numberPressed:numberButton.titleLabel.text.integerValue];
}

- (IBAction)clearTouched:(id)sender {
    [numericKeyboardDelegate clearTouched];
}

@end