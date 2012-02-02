#import <UIKit/UIKit.h>
@protocol ControlKeysKeyboardDelegate
- (void)submitPressed;
- (void)clearTouched;
@end

@interface ControlKeysKeyboardController : UIViewController
- (id)initWithDelegate:(id<ControlKeysKeyboardDelegate>)controlKeysKeyboardDelegate;

- (IBAction)submitAnswer:(id)sender;
- (IBAction)clearTouched:(id)sender;
@end
