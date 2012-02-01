#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"

@interface ConfigurationViewController : UIViewController<ColorPickerDelegate>
- (IBAction)okTouched:(id)sender;
- (id)initWithParent:(id<ColorPickerDelegate>)parent;
@end
