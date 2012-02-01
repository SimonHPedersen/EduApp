#import <UIKit/UIKit.h>
@protocol ColorPickerDelegate
- (void) valueDidChange:(float)value;

@end

@interface ColorPickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (id)initWithDelegate:(id<ColorPickerDelegate>)delegate;
- (IBAction)valueChanged:(id)sender;
@end
