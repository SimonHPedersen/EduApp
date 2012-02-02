#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LibraryConverter.h"

@interface ConfigurationViewController : UIViewController<MPMediaPickerControllerDelegate,ColorPickerDelegate,LibraryConverterDelegate>
- (IBAction)okTouched:(id)sender;
- (id)initWithParent:(id<ColorPickerDelegate>)parent;
@property (weak, nonatomic) id<LibraryConverterDelegate> libraryConverterDelegate;
@end
