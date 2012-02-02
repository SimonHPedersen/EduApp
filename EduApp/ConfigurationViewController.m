#import "ConfigurationViewController.h"

@interface ConfigurationViewController() 
@property (weak, nonatomic) id<ColorPickerDelegate> colorPickerDelegate;
@property (strong, nonatomic) ColorPickerViewController* colorPickerViewController;
@property (strong, nonatomic) LibraryConverter *converter;
@end

@implementation ConfigurationViewController
@synthesize colorPickerDelegate;
@synthesize colorPickerViewController;
@synthesize converter;
@synthesize libraryConverterDelegate;

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
    
    [self valueDidChange:self.colorPickerViewController.slider.value];
    
    self.converter = [[LibraryConverter alloc] init];
    self.converter.delegate = self;
    
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

#pragma mark - Media Player stuff

// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {
    
	MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= NO;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
    
	[self presentModalViewController: picker animated: YES];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	[self dismissModalViewControllerAnimated: YES];
    
    NSArray *items = [mediaItemCollection items];
    MPMediaItem *item = [items objectAtIndex:0];
    [self.converter convert:item];
    NSLog(@"%@",[item valueForProperty:MPMediaItemPropertyAssetURL]);
    
    
    
//	[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
//	[self.mediaItemCollectionTable reloadData];
    
//	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissModalViewControllerAnimated: YES];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}

# pragma mark - LibraryConverterDelegate

-(void)conversionDidProgress:(float)progress
{
    [self.libraryConverterDelegate conversionDidProgress:progress];
}

-(void)conversionDidFinish:(NSString *)songUrl
{
    [self.libraryConverterDelegate conversionDidFinish:songUrl];
}



@end
