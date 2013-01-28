//
//  Action2ViewController.h
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import <UIKit/UIKit.h>
#import "addTeachWord.h"
#import "FileOPs.h"

@interface Action2ViewController : UIViewController<addTeachWordDelegate>{
    UIScrollView *scrollView;
    UILabel *countdownLabel;
    UIImageView *imageView;
    UIImage *image;
    UIButton *StartBtn;
    UIButton *OkBtn;
    NSTimer *timer;
    UILabel *tip;
    FileOPs *saveFile;
    int minutes;
    int seconds;
    int secondsLeft;
    NSMutableDictionary *AnswerDic;
    UIAlertView *tellTimeStart,*tellTimeStop;
    UIStoryboard *secondStoryboard;
    addTeachWord *addTeachingWord;
}
-(void)StartCountDownTimer:(id)sender;
@end
