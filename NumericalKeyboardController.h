#import <UIKit/UIKit.h>

@protocol NumericKeyboardDelegate
- (void)numberPressed:(int)number;
@end

@interface NumericalKeyboardController : UIViewController
- (id)initWithDelegate:(id<NumericKeyboardDelegate>)numericKeyboarDelegate;

- (IBAction)numberPressed:(id)sender;
@end
