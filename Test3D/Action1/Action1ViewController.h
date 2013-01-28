//
//  Action1ViewController.h
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import <UIKit/UIKit.h>

#import "addTeachWord.h"
#import "Action2ViewController.h"
#import "FileOPs.h"

@interface Action1ViewController : UIViewController<addTeachWordDelegate>{
    UIScrollView *scrollView;
    UILabel *countdownLabel;
    UIImageView *imageView;
    UIImage *image;
    UIButton *StartBtn;
    UIButton *OkBtn;
    NSTimer *timer;
    FileOPs *saveFile;
    UIAlertView *tellTimeStart;
    UIAlertView *tellTimeStop;
    UILabel *tip;
    int minutes;
    int seconds;
    int secondsLeft;
    int PressCount;
    UIStoryboard *Storyboard;
    NSMutableDictionary *AnswerDic;
    
    addTeachWord *addTeachingWord;
}
-(void)StartCountDownTimer:(id)sender;
@end
