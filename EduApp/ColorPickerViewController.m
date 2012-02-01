#import "ColorPickerViewController.h"

@interface ColorPickerViewController()
@property (nonatomic,weak) id<ColorPickerDelegate>delegate;

@end

@implementation ColorPickerViewController
@synthesize slider;
@synthesize delegate=_delegate;

- (id)initWithDelegate:(id<ColorPickerDelegate>)delegate {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
}

- (void)viewDidUnload
{
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)valueChanged:(id)sender {
    [self.delegate valueDidChange:self.slider.value];
}
@end
