#import <UIKit/UIKit.h>

@protocol NumericKeyboardDelegate
- (void)numberPressed:(int)number;
- (void)submitPressed;
- (void)clearTouched;
@end

@interface NumericalKeyboardController : UIViewController
- (id)initWithDelegate:(id<NumericKeyboardDelegate>)numericKeyboarDelegate;

- (IBAction)submitAnswer:(id)sender;
- (IBAction)numberPressed:(id)sender;
- (IBAction)clearTouched:(id)sender;
@end
