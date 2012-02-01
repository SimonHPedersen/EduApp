#import <UIKit/UIKit.h>

@interface CalculateViewController : UIViewController<UITextFieldDelegate> {
    
    __weak IBOutlet UILabel *problemLabel;
    __weak IBOutlet UITextField *answerField;
    __weak IBOutlet UILabel *equalsLabel;
    __weak IBOutlet UIView *underscoreView;
}
@property int number1;
@property int number2;

- (IBAction)answerEntered:(id)sender;
@end
