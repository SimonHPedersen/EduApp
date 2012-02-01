#import "ConfigurationViewController.h"

@interface ConfigurationViewController() 
@property (weak, nonatomic) id<ColorPickerDelegate> colorPickerDelegate;
@property (strong, nonatomic) ColorPickerViewController* colorPickerViewController;
@end

@implementation ConfigurationViewController
@synthesize colorPickerDelegate;
@synthesize colorPickerViewController;

- (id)initWithParent:(id<ColorPickerDelegate>)parent
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.colorPickerDelegate = parent;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.colorPickerViewController = [[ColorPickerViewController alloc] initWithDelegate:self];
    [self.view addSubview:self.colorPickerViewController.view];
    CGRect frame = self.colorPickerViewController.view.frame;
    frame = CGRectOffset(frame, (self.view.frame.size.height - frame.size.width) / 2.0, 0);
    self.colorPickerViewController.view.frame = frame;
    
    [self.view addSubview:self.colorPickerViewController.view];
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

- (IBAction)okTouched:(id)sender {
    [self.view removeFromSuperview];
}

- (void)valueDidChange:(float)value{
        self.view.backgroundColor = [UIColor colorWithHue:value saturation:1 brightness:0.3 alpha:1.0];
    
    [self.colorPickerDelegate valueDidChange:value];
}
@end
