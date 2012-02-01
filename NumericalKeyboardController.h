#import <UIKit/UIKit.h>

@protocol NumericKeyboardDelegate
- (void)numberPressed:(int)number;
- (void)submitPressed;
@end

@interface NumericalKeyboardController : UIViewController
- (id)initWithDelegate:(id<NumericKeyboardDelegate>)numericKeyboarDelegate;

- (IBAction)submitAnswer:(id)sender;
- (IBAction)numberPressed:(id)sender;
@end
