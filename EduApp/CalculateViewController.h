#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"
#import "Question.h"

@interface CalculateViewController : UIViewController<UITextFieldDelegate,ColorPickerDelegate> {
    
    __weak IBOutlet UILabel *problemLabel;
    __weak IBOutlet UITextField *answerField;
    __weak IBOutlet UILabel *equalsLabel;
    __weak IBOutlet UIView *underscoreView;
}
@property (strong, nonatomic) Question* question;
@end
