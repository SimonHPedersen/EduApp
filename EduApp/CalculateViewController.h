#import <UIKit/UIKit.h>

@interface CalculateViewController : UIViewController<UITextFieldDelegate> {
    
    __weak IBOutlet UILabel *number1Label;
    __weak IBOutlet UILabel *number2Label;
    __weak IBOutlet UILabel *operatorLabel;
    __weak IBOutlet UITextField *answerField;
}
@property int number1;
@property int number2;
@property int totalCounter;
@property int rightCounter;


- (IBAction)answerEntered:(id)sender;


@end
