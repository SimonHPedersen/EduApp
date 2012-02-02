#import "ControlKeysKeyboardController.h"
@interface ControlKeysKeyboardController()
@property (strong, nonatomic) id<ControlKeysKeyboardDelegate> controlKeysKeyboardDelegate;
@end

@implementation ControlKeysKeyboardController
@synthesize controlKeysKeyboardDelegate=_controlKeysKeyboardDelegate;

- (id)initWithDelegate:(id<ControlKeysKeyboardDelegate>)controlKeysKeyboardDelegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.controlKeysKeyboardDelegate = controlKeysKeyboardDelegate;
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
    [self.controlKeysKeyboardDelegate submitPressed];
}

- (IBAction)clearTouched:(id)sender {
    [self.controlKeysKeyboardDelegate clearTouched];
}


@end
