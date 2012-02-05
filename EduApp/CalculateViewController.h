#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"
#import "Question.h"
#import "NumericalKeyboardController.h"
#import "ControlKeysKeyboardController.h"
#import "LibraryConverter.h"

@interface CalculateViewController : UIViewController<ColorPickerDelegate, NumericKeyboardDelegate, ControlKeysKeyboardDelegate, LibraryConverterDelegate> {
    
    __weak IBOutlet UILabel *problemLabel;
    __weak IBOutlet UILabel *equalsLabel;
    __weak IBOutlet UIView *underscoreView;
    __weak IBOutlet UILabel *answerLabel;
}
@property (strong, nonatomic) Question* question;
- (IBAction)informationTouched:(id)sender;
@end
