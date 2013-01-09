//
//  ActionCover.h
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "Action1ViewController.h"
#import "Test3DAppDelegate.h"
#import "FileOPs.h"

@interface ActionCover : UIViewController
{
    NSMutableDictionary *persondata;
    NSString *sexstring;
    UIDatePicker *datePicker;
    NSString *datestring;
    AppDelegate *delegate;
    FileOPs *saveFile;
    BOOL T0;
    BOOL T1;
    BOOL T2;
    BOOL T3;
    BOOL T4;
    BOOL T5;
    BOOL checkS;
}
@property (nonatomic, assign) IBOutlet UITextField *TestNumber;
@property (nonatomic, assign) IBOutlet UITextField *StudentName;
@property (nonatomic, assign) IBOutlet UITextField *SchoolName;
@property (nonatomic, assign) IBOutlet UITextField *GradeYear;
@property (nonatomic, assign) IBOutlet UILabel *TestDay;
@property (nonatomic, assign) IBOutlet UILabel *Birthday;
@property (nonatomic,retain) NSMutableDictionary *dic;
- (IBAction)TestDayBtn:(id)sender;

- (IBAction)BirthDayBtn:(id)sender;
@end
