#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ConfigurationViewController : UIViewController<MPMediaPickerControllerDelegate,ColorPickerDelegate>
- (IBAction)okTouched:(id)sender;
- (id)initWithParent:(id<ColorPickerDelegate>)parent;
@end
